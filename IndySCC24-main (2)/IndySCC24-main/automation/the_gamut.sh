#!/usr/bin/env bash

# Enable strict error handling, but allow controlled error handling
set -uo pipefail
IFS=$'\n\t'

# Script configuration
readonly BASE_HOSTNAME="scc135-cpu"
readonly USER="rocky"
readonly NFS_BASE="/nfs/general"
readonly NFS_IP="10.3.143.84"
readonly SETUP_DIR="${NFS_BASE}/resources/setup/scripts"
readonly SCRIPTS_DIR="${SETUP_DIR}/scripts"
readonly LOG_DIR="${NFS_BASE}/logs"
readonly LOG_FILE="${LOG_DIR}/setup_$(date +%Y%m%d_%H%M%S).log"
readonly MAX_RETRIES=3
readonly RETRY_DELAY=30  # seconds

# Function to log messages
log() {
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[${timestamp}] $*" | tee -a "${LOG_FILE}"
}

# Function to log errors
error() {
    log "ERROR: $*" >&2
}

retry_command() {
    local -r cmd="${1}"
    local -r description="${2}"
    local retries=0
    
    while [ $retries -lt $MAX_RETRIES ]; do
        log "Executing: ${cmd}"
        if eval "$cmd" 2>&1 | tee -a "${LOG_FILE}"; then
            log "${description} - Succeeded"
            return 0
        else
            local exit_code=$?
            retries=$((retries + 1))
            error "${description} - Failed with exit code ${exit_code} (Attempt ${retries}/${MAX_RETRIES})"
            if [ $retries -lt $MAX_RETRIES ]; then
                log "Waiting ${RETRY_DELAY} seconds before retrying..."
                sleep "${RETRY_DELAY}"
            fi
        fi
    done
    
    error "${description} - Failed all retry attempts"
    return 1
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to verify prerequisites
check_prerequisites() {
    log "Checking prerequisites..."
    local -a required_commands=("ssh" "scp" "sudo")
    local failed=0
    
    for cmd in "${required_commands[@]}"; do
        if ! command_exists "$cmd"; then
            error "Required command '${cmd}' not found"
            failed=1
        fi
    done
    
    if [ $failed -eq 1 ]; then
        return 1
    fi
}

# Function to setup directories
setup_directories() {
    log "Creating necessary directories..."
    if ! sudo mkdir -p "${SCRIPTS_DIR}" "${LOG_DIR}"; then
        error "Failed to create directories"
        return 1
    fi
    if ! sudo chmod 755 "${SCRIPTS_DIR}" "${LOG_DIR}"; then
        error "Failed to set directory permissions"
        return 1
    fi
}

# Function to copy setup files
copy_setup_files() {
    log "Copying setup files to NFS..."
    if ! cd "/home/${USER}/IndySCC24/automation"; then
        error "Failed to change to automation directory"
        return 1
    fi
    
    log "Current directory: $(pwd)"
    log "Files to be copied: $(ls -la)"
    
    if ! sudo cp -r ./* "${SCRIPTS_DIR}"; then
        error "Failed to copy setup files"
        return 1
    fi
    
    if ! cd "${SCRIPTS_DIR}"; then
        error "Failed to change to scripts directory"
        return 1
    fi
    
    log "Destination directory contents: $(ls -la)"
    
    if ! sudo chmod +x ./*; then
        error "Failed to make scripts executable"
        return 1
    fi
}

# Function to setup login node
setup_login_node() {
    log "Setting up login node..."
    local failed=0
    
    log "Running get_ips.sh..."
    log "Current directory: $(pwd)"
    log "Script permissions: $(ls -l get_ips.sh)"
    
    # Try running get_ips directly first
    if ! ./get_ips.sh "${NUM_HOSTS}" >> "${LOG_DIR}/ips.txt" 2>&1; then
        error "Direct execution of get_ips.sh failed, trying with bash..."
        if ! bash ./get_ips.sh "${NUM_HOSTS}" > "${LOG_DIR}/ips.txt" 2>&1; then
            error "Failed to get IPs even with bash"
            failed=1
        fi
    fi
    
    # Show the contents of ips.txt regardless of success/failure
    log "Contents of ips.txt (if it exists):"
    cat "${LOG_DIR}/ips.txt" 2>&1 | tee -a "${LOG_FILE}" || true
    
    # NFS Setup
    if ! retry_command "./login_nfs_setup.sh" "NFS Setup"; then
        error "Failed to setup NFS"
        failed=1
    fi
    
    # AOCC Setup
    if ! retry_command "./aocc_setup.sh" "AOCC Setup"; then
        error "Failed to setup AOCC"
        failed=1
    fi
    
    # Spack Setup
    if ! retry_command "./spack_setup.sh" "Spack Setup"; then
        error "Failed to setup Spack"
        failed=1
    fi
    
    return $failed
}

# Function to setup a single compute node
setup_single_compute_node() {
    local hostname="$1"
    
    log "Setting up node: ${hostname}"
    
    # Test SSH connection
    if ! retry_command "ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no ${hostname} 'echo SSH connection successful'" "SSH Test ${hostname}"; then
        error "Cannot connect to ${hostname}"
        return 1
    fi
    
    # Perform node setup
    if ! retry_command "ssh -o StrictHostKeyChecking=no ${hostname} '
        set -e
        echo \"Setting up \$(hostname)\"
        sudo dnf update -y
        ./cpu_nfs_setup \"${NFS_IP}\"
        cd \"${SCRIPTS_DIR}\"
        ./aocc_setup.sh
        ./spack_setup.sh 
    '" "Setup ${hostname}"; then
        error "Failed to setup ${hostname}"
        return 1
    fi
    
    return 0
}

# Function to setup compute nodes
setup_compute_nodes() {
    log "Setting up compute nodes..."
    local failed_nodes=()
    
    for i in $(seq 0 $((NUM_HOSTS-1))); do
        local hostname="${USER}@${BASE_HOSTNAME}${i}"
        
        if ! setup_single_compute_node "${hostname}"; then
            failed_nodes+=("${hostname}")
            error "Failed to setup ${hostname}, continuing with next node..."
        fi
    done
    
    # Report failed nodes
    if [ ${#failed_nodes[@]} -ne 0 ]; then
        error "The following nodes failed to setup:"
        printf '%s\n' "${failed_nodes[@]}" | tee -a "${LOG_FILE}"
        return 1
    fi
    
    return 0
}

# Main execution
main() {
    # Verify argument count
    if [ $# -ne 1 ]; then
        echo "Error: Please provide the number of hosts to set up"
        echo "Usage: $0 <number_of_hosts>"
        exit 1
    fi

    # Store and validate the argument
    NUM_HOSTS=$1
    if ! [[ "${NUM_HOSTS}" =~ ^[0-9]+$ ]]; then
        echo "Error: Number of hosts must be a positive integer"
        exit 1
    fi

    log "Starting cluster setup for ${NUM_HOSTS} hosts"
    
    # Run setup steps
    check_prerequisites || exit 1
    setup_directories || exit 1
    copy_setup_files || exit 1
    setup_login_node || exit 1
    setup_compute_nodes || exit 1
    
    log "Cluster setup completed"
}

# Execute main function with all arguments
main "$@"
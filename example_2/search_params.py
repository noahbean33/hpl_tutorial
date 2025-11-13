# Script to search for HPL.dat values.
# Comments are quotes from https://www.netlib.org/benchmark/hpl/tuning.html.

import shutil
import subprocess
from itertools import product
import time

TEMPLATE = """HPLinpack benchmark input file
@INFO@
HPL.out      output file name (if any)
6            device out (6=stdout,7=stderr,file)
1            # of problems sizes (N)
@N@ Ns
1            # of NBs
@NB@ NBs
@PMAP@ PMAP process mapping (0=Row-,1=Column-major)
1            # of process grids (P x Q)
@P@ Ps
@Q@ Qs
@THRES@ threshold
1            # of panel fact
@PFACT@ PFACTs (0=Left, 1=Crout, 2=Right)
1            # of recursive stopping criterium
@NBMIN@ NBMINs (>= 1)
1            # of panels in recursion
@NDIV@ NDIVs
1            # of recursive panel fact.
@RFACT@ RFACTs (0=Left, 1=Crout, 2=Right)
1            # of broadcast
@BCAST@ BCASTs (0=1rg,1=1rM,2=2rg,3=2rM,4=Lng,5=LnM)
1            # of lookahead depth
@DEPTH@ DEPTHs (>=0)
@SWAP@ SWAP (0=bin-exch,1=long,2=mix)
@SWAP_THRES@ swapping threshold
@L1@ L1 in (0=transposed,1=no-transposed) form
@U@ U  in (0=transposed,1=no-transposed) form
@E@ Equilibration (0=no,1=yes)
8            memory alignment in double (> 0)
"""

BEST_CONFIG = {
    "INFO": "Auto-tuned HPL config",
    "N": 22848, # ~5 seconds
    "NB": 192,
    "P": 16,
    "Q": 8,
    "PMAP": 0,
    "PFACT": 1,
    "NBMIN": 4,
    "NDIV": 2,
    "RFACT": 1,
    "BCAST": 1,
    "DEPTH": 1,
    "SWAP": 1,
    "SWAP_THRES": 64,

    "L1": 0,
    "U": 0,
    # I do not think Line 28 matters. Pick 0 in doubt. Line 29
    # is more important. It controls how the panel of rows should
    # be stored. No doubt 0 is better. The caveat is that in that
    # case the matrix-multiply function is called with ( Notrans,
    # Trans, ... ), that is C := C - A B^T. Unless the computational
    # kernel you are using has a very poor (with respect to performance)
    # implementation of that case, and is much more efficient with
    # ( Notrans, Notrans, ... ) just pick 0 as well.

    "E": 1,
    # Not knowing much about the random matrix generated and
    # because the overhead is so small compared to the possible
    # gain, I turn it on all the time.

    "THRES": -16.0
    # It is allowed to specify a negative value for this threshold,
    # in which case the checks will be by-passed, no matter what the
    # threshold value is, as soon as it is negative. This feature
    # allows to save time when performing a lot of experiments,
    # say for instance during the tuning phase.
}

TUNING_GROUPS = [
    {"SWAP": [0, 1, 2]},
    {"PMAP": [0, 1], "P": [p for p in range(4, 33, 2) if 128 % p == 0]},  # Q = 128 // P

    {"BCAST": [0, 1, 2, 3, 4, 5]},
    # HPL offers various choices and one most likely
    # want to use the increasing ring modified encoded
    # as 1. 3 and 4 are also good choices.
    # My take is that 4 or 5 may be competitive for
    # machines featuring very fast nodes comparatively to the network.

    {"DEPTH": [0, 1, 2]},
    # as mentioned above 0 or 1 are likely to be the best choices
    # Look-ahead of depths 3 and larger will probably not give you better results.

    {"PFACT": [0, 1, 2], "NBMIN": [1, 2, 4, 8], "NDIV": [2, 3, 4], "RFACT": [0, 1, 2]},
    # {"THRES": [2.0, 8.0, 16.0, 32.0]},
]

def generate_hpl_dat(config, output_path):
    content = TEMPLATE
    for key, value in config.items():
        content = content.replace(f"@{key.upper()}@", f"{value:<12}")
    with open(output_path, 'w') as f:
        f.write(content)

def run_hpl():
    time.sleep(10)
    try:
        process = subprocess.Popen(
            ['make', 'run_multi_verbose'],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            bufsize=1
        )

        if process.stdout is None:
            process.kill()
            return

        for line in process.stdout:
            print(line, end='')

        process.kill()

    except subprocess.TimeoutExpired:
        print("HPL run timed out.")
    except Exception as e:
        print(f"Error running HPL: {e}")

def copy_to_hpl_bin(source_path):
    dest = "./HPL.dat"
    shutil.copy(source_path, dest)


def main():
    config = BEST_CONFIG.copy()
    temp_hpl_path = "./temp_HPL.dat"
    i = 0

    for group in TUNING_GROUPS:
        group_keys = list(group.keys())
        print(f"\n=== TUNING GROUP: {group_keys} ===")

        # Special handling for (P, Q)
        if "P" in group and "PMAP" in group:
            for p in group["P"]:
                q = 128 // p
                for pmap in group["PMAP"]:
                    test_config = config.copy()
                    test_config.update({"P": p, "Q": q, "PMAP": pmap})
                    generate_hpl_dat(test_config, temp_hpl_path)
                    copy_to_hpl_bin(temp_hpl_path)
                    print(f"Run {i} Test (P={p}, Q={q}, PMAP={pmap})")
                    i += 1
                    run_hpl()
        else:
            # Standard group handling
            value_lists = [group[k] for k in group_keys]
            for values in product(*value_lists):
                overrides = dict(zip(group_keys, values))
                test_config = config.copy()
                test_config.update(overrides)
                generate_hpl_dat(test_config, temp_hpl_path)
                copy_to_hpl_bin(temp_hpl_path)

                desc = ", ".join([f"{k}={v}" for k, v in overrides.items()])
                print(f"Run {i} Test ({desc})")
                i += 1
                run_hpl()

if __name__ == "__main__":
    main()

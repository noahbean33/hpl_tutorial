# Run MPI with `perf` and OMB
mpiexec \
    --hostfile hostfile \
    # --host node01:56,node04:36,node06:36,node07:32,node08:32 \
    --bind-to core \
    --report-bindings \
    --mca btl '^uct,tcp,vader,openib' \
    --mca btl_tcp_if_include ib0 \
    --mca pml ucx \
    # -x UCX_NET_DEVICES=mlx5_0:1 \
    # -x HCOLL_MAIN_IB=mlx5_0:1 \
    -x UCX_LOG_LEVEL=info \
    -x PATH \
    -x LD_LIBRARY_PATH \
    bash -c 'perf record --call-graph=dwarf -o perf.data.$OMPI_COMM_WORLD_RANK osu_allreduce'
    
# Convert to a visualizer-compatible format
perf script -i perf.data.0 > out.perf

# Upload file to https://www.speedscope.app/
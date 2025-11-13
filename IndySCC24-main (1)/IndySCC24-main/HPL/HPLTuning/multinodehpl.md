# E

```json
mpirun -np 6  --host scc135-cpu1:2,scc135-cpu2:2,scc135-cpu3:2 --prefix ${MPI_HOME} xhpl    
```

on login node, `echo $MPI_HOME` should return `/nfs/general/mpi/.tools/`

```json
echo |cpp -fopenmp -dM |grep -i open
```

HPL Location

```json
/nfs/general/hpl/bin
```

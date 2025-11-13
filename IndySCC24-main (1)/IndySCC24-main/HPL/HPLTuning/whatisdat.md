# Tuning HPL.dat

## HPL Config Parameters

Below is the default HPL.dat file provided on first build.
This default file is not optimized for anything.

```
HPLinpack benchmark input file
Innovative Computing Laboratory, University of Tennessee
HPL.out      output file name (if any)
6            device out (6=stdout,7=stderr,file)
4            # of problems sizes (N)
29 30 34 35  Ns
4            # of NBs
1 2 3 4      NBs
0            PMAP process mapping (0=Row-,1=Column-major)
3            # of process grids (P x Q)
2 1 4        Ps
2 4 1        Qs
16.0         threshold
3            # of panel fact
0 1 2        PFACTs (0=left, 1=Crout, 2=Right)
2            # of recursive stopping criterium
2 4          NBMINs (>= 1)
1            # of panels in recursion
2            NDIVs
3            # of recursive panel fact.
0 1 2        RFACTs (0=left, 1=Crout, 2=Right)
1            # of broadcast
0            BCASTs (0=1rg,1=1rM,2=2rg,3=2rM,4=Lng,5=LnM)
1            # of lookahead depth
0            DEPTHs (>=0)
2            SWAP (0=bin-exch,1=long,2=mix)
64           swapping threshold
0            L1 in (0=transposed,1=no-transposed) form
0            U  in (0=transposed,1=no-transposed) form
1            Equilibration (0=no,1=yes)
8            memory alignment in double (> 0)
```

### Breakdown

> ```r
> HPL.out      output file name (if any)
> ```

* Specify output file
* If no output file exists under that name, it will make a new one, otherwise it will overwrite the existing file
* If you stop early, the output is still redirected to the appropriate file up until the point of stopping

>```r
> 6            device out (6=stdout,7=stderr,file)
>```

* 6 = outputs results in terminal
* integer other than 6/7 = outputs in output file name above
* If the integer is 6 or 7, no output file will be made regardless of whether you specified an output file name

>```r
> 4            # of problems sizes (N)
>```

* How many problems do you want to run?
* If you have specified more than one, they will run sequentially.

>```r
> 29 30 34 35  Ns
>```

* This example shows 4 problems of sizes 29, 30, 34, 35
* Sizes of the different problems
* The recommended problem sizes should fall between 70%-90% memory
* Calculate the memory with [this tool](#psize)
* Will run sequentially

>```r
> 4            # of NBs
>```

* Number of block sizes (<=20)
* If you have specified more than one, they will run sequentially

>```r
> 1 2 3 4      NBs
>```

* Block sizes to be run
* Block sizes should be a multiple of the # of cores used
* Should not be too big nor too small and usually <384 or <512
* Will run sequentially

>```r
> 3            # of process grids (P x Q)
>```

* If multiple process grids, will run sequentially
* \>1 process grids is also for \>1 problems

> ```r
> 2 1 4        Ps
> 2 4 1        Qs
>```

* This example shows 3 process grids of sizes 2x2, 1x4, 4x1
* P x Q = total processors (2D processor grid)
* P = # processors for rows
* Q = # processors for columns
* In most cases, you want P <= Q
  * Aim for "square" or "slightly flat" grids
  * Stay away from 1xQ or Px1 grids unless very small
  * Number and data volume of communications in cols > rows
* Recommended to set the value of P to an exponential power of 2
  * Binary exchange for horizontal communication = FLOPS optimal when P = 2^n

## Resources

<a name="psize"></a>**[HPL Problem Size Calculator](https://www.desmos.com/calculator/y1d9nhb54c)**

The HPL Problem Size Calculator is based on the HPL FAQs found on [Netlib](https://netlib.org/benchmark/hpl/faqs.html) and [UTK's ICL page](https://icl.utk.edu/hpl/faq/index.html#275). Adjust percent memory used as needed.

**[Open Power HPL Tuning](https://github.com/open-power/op-benchmark-recipes/blob/master/standard-benchmarks/HPL/Linpack_HPL.dat_tuning.md)**

**[Alibaba Cloud HPL Guide (Testing FLOPS in E-HPC Cluster)](https://www.alibabacloud.com/help/en/e-hpc/e-hpc-1-0/use-cases/use-hpl-to-test-the-flops-of-an-e-hpc-cluster)**

**[Advanced Clustering: Tune HPL File](https://www.advancedclustering.com/act_kb/tune-hpl-dat-file/)**

Given:

* Nodes
* Cores per node
* Memory per node (MiB)
* Block size (NB)

Output:

* Optimized .dat file

This optimized .dat file matches our assumptions and our own .dat files.

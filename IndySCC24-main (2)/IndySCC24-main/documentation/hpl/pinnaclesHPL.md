# How to Build HPL on Pinnacles

Required dependencies:

- compiler
- MPI
- BLAS

We will be using:

- HPL 2.3
- Intel MKL

1. Download and untar HPL source tarball

    ```shell
    tar -xf hpl-2.3.tar.gz
    ```

2. Load necessary modules. BLAS is included in Intel MKL.

    ```shell
    module load openmpi/4.1.4-gcc-12.2.0
    ```

    ```shell
    module load intel/oneapi
    ```
  
    Don't worry about the errors that pop up after loading OneAPI!

    ```shell
    module load tbb/2021.12
    ```

    ```shell
    module load compiler-rt/2024.1.2
    ```

    ```shell
    module load mkl/2024.1
    ```

3. `vim Make.Linux_Intel64` to edit `mpiicc` to `mpicc`
   1. To find "mpiicc"
   `ESC -> /mpiicc -> ENTER to finish search`
   2. To change "mpiicc" -> "mpicc" you want to trigger "INSERT" by pressing
   `i`
   And then get out of INSERT by pressing
   `ESC`
   3. To save and exit
   `:wq -> ENTER` OR `ZZ -> ENTER`
   To exit without saving
   `:q!`

4. `./configure`
5. `make arch=Linux_Intel64`
6. `cd testing/`
7. Your HPL.dat file will be in either `pmatgen` or `ptest` in the `testing` folder.
    While in the testing folder, move it out:
    `mv ptest/HPL.dat .` OR `mv pmatgen/HPL.dat .`
    
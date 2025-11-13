# HPL

# 🧮 HPL CPU Memory Benchmark (Ubuntu 22.04)

This project provides a concise Docker environment for running the **HPL (High Performance Linpack) test on a CPU**.
It primarily measures **CPU floating-point performance (GFLOPS)** and **memory computation performance**.
It does not include GPU support, making it suitable for benchmarking the CPU performance of servers or HPC nodes.

-----

## 📂 Project Structure

```
hpl-cpu-test/
├── Dockerfile      # Builds the CPU version of the HPL image
├── Make.Linux_CPU  # HPL compilation settings
├── HPL.dat         # Test parameters (matrix size, block size, process grid)
├── entrypoint.sh   # Automatic execution script
└── README.md       # Project description
```

-----

## 🧱 1. Build the Docker Image

Execute the following command in the project's root directory:

```bash
docker build -t hpl-cpu-test .
```

This will:

1.  Install OpenBLAS + MPI
2.  Download and compile HPL (v2.3)
3.  Copy configuration files and the startup script

## ▶️ 2. Run the Test

```bash
docker run --rm -v $(pwd)/logs:/workspace/logs hpl-cpu-test
```

After execution:

  * HPL will run inside the `/workspace` directory.
  * A test log file will be automatically generated, for example:
    ```bash
    /workspace/hpl_20251024_1530.log
    ```
  * The results will include:
      * Problem size (N)
      * Block size (NB)
      * Number of cores used
      * Actual execution time
      * GFLOPS (Giga-floating-point operations per second)

## ⚙️ 3. Adjust Test Parameters

You can edit `HPL.dat` to control memory usage and load:

| Parameter | Description | Recommended Value |
| :--- | :--- | :--- |
| Ns | Matrix size (N) | The larger the value, the more memory is consumed, e.g., 20000–80000 |
| NBs | Block size | Generally 128 or 256 |
| Ps / Qs | Process grid layout | Can be adjusted according to the number of cores, e.g., 2x2 or 4x4 |

## 🧩 4. Log Analysis

Opening the log file will show something similar to this:

```css
T/V         N      NB     P     Q             Time                 Gflops
WR11R2R4    20000  256    2     2             550.00               9.20
```

This indicates:

  * Test matrix size is 20000
  * Used 4 cores (2x2)
  * Execution time was 550 seconds
  * Performance is 9.20 GFLOPS

## 💡 5. Common Adjustment Suggestions

| Goal | Method |
| :--- | :--- |
| Want to test larger memory | Increase `Ns` |
| Want to run faster | Adjust `Ps` and `Qs` for a more balanced layout |
| Want to output to a result file | Add `tee logs/output.log` inside `entrypoint.sh` |
| Want to run multiple times for an average | Use a bash loop to execute `docker run` multiple times |

## 🧰 6. System Requirements

  * **OS**: Ubuntu 22.04 (or any Linux distribution that supports Docker)
  * **CPU**: x86\_64 architecture, 4 cores or more recommended
  * **Memory**: At least 4GB (16GB or more recommended)
  * **Disk Space**: Approximately 1GB
  
# HPL
# 🧮 HPL CPU Memory Benchmark (Ubuntu 22.04)

這個專案提供一個簡潔的 Docker 環境，用於在 **CPU 上執行 HPL（High Performance Linpack）** 測試，  
主要測量 **CPU 浮點效能 (GFLOPS)** 與 **記憶體運算表現**。  
不包含 GPU，適合做伺服器或 HPC 節點的 CPU 性能基準測試。

---

## 📂 專案結構

hpl-cpu-test/
├── Dockerfile # 建置 CPU 版 HPL 映像
├── Make.Linux_CPU # HPL 編譯設定
├── HPL.dat # 測試參數（矩陣大小、區塊大小、處理網格）
├── entrypoint.sh # 自動執行腳本
└── README.md # 專案說明

yaml
コードをコピーする

---

## 🧱 1. 建置 Docker 映像

在專案根目錄執行：

```bash
docker build -t hpl-cpu-test .
這會：

安裝 OpenBLAS + MPI

下載並編譯 HPL (v2.3)

複製設定檔與啟動腳本

▶️ 2. 執行測試
bash
コードをコピーする
docker run --rm -v $(pwd)/logs:/workspace/logs hpl-cpu-test
執行後：

會在 /workspace 內運行 HPL

自動產生測試 log 檔案，例如：

bash
コードをコピーする
/workspace/hpl_20251024_1530.log
結果會包含：

問題尺寸 (N)

區塊大小 (NB)

使用核心數

實際執行時間

GFLOPS（每秒浮點運算量）

⚙️ 3. 調整測試參數
你可以編輯 HPL.dat 來控制記憶體與負載：

參數	說明	建議值
Ns	矩陣大小（N）	越大越吃記憶體，例如 20000～80000
NBs	區塊大小	一般用 128 或 256
Ps / Qs	處理節點佈局	可依核心數調整，例如 2x2 或 4x4

🧩 4. Log 分析
打開 log 可看到類似：

css
コードをコピーする
T/V                N    NB     P     Q               Time                 Gflops
WR11R2R4      20000   256     2     2             550.00              9.20
表示：

測試矩陣大小為 20000

使用 4 核 (2x2)

執行時間 550 秒

性能為 9.20 GFLOPS

💡 5. 常見調整建議
需求	方法
想測更大記憶體	增加 Ns
想跑更快	調整 Ps、Qs 讓佈局更均衡
想輸出成結果檔	在 entrypoint.sh 內加上 tee logs/output.log
想跑多次取平均	用 bash 迴圈執行多次 docker run

🧰 6. 系統需求
Ubuntu 22.04（或任意支援 Docker 的 Linux）

CPU：x86_64 架構，建議 4 核以上

記憶體：至少 4GB（建議 16GB 以上）

約 1GB 磁碟空間


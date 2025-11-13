#!/bin/bash
set -e

echo "=== Running HPL CPU Memory Benchmark ==="
cd /opt/hpl-2.3/bin/Linux_CPU

mpirun -np $(nproc) ./xhpl | tee /workspace/hpl_$(date +%Y%m%d_%H%M).log

echo "✅ 測試完成，結果已輸出到 /workspace/"

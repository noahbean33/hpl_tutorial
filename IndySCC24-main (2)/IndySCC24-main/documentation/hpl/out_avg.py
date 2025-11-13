import re
import numpy as np
from collections import defaultdict

def get_gflops(file_path):
    with open(file_path, 'r') as file:
        file_content = file.read()

    pattern = r"\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+\d+\.\d+\s+(\d+\.\d+e[+-]\d+)"
    
    # Dictionary to store Gflops by parameter combinations
    gflops_dict = defaultdict(list)

    matches = re.findall(pattern, file_content)

    # Iterate over matches and group Gflops by parameters
    for match in matches:

        N, NB, P, Q, gflops = match
        N, NB, P, Q = int(N), int(NB), int(P), int(Q)
        gflops = float(gflops)
        
        gflops_dict[(N, NB, P, Q)].append(gflops)

    return gflops_dict

def calculate_averages(gflops_dict):

    averages = {params: np.mean(gflops) for params, gflops in gflops_dict.items()}
    return averages

file_path = 'HPL.out'

# Gflops grouped by parameters
gflops_dict = get_gflops(file_path)

# Calculate averages for each parameter combination
averages = calculate_averages(gflops_dict)

for params, avg_gflops in averages.items():

    print(f"Parameters (N={params[0]}, NB={params[1]}, P={params[2]}, Q={params[3]}) - Average Gflops: {avg_gflops:.4f}")

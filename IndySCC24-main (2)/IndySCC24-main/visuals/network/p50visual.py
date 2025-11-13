import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Read the data
data = pd.read_csv('performance-data.csv')

# Create the scatter plot
plt.figure(figsize=(12, 8))

# Plot Pre data points and trendline
pre_data = data[data['Type'] == 'Pre']
plt.scatter(pre_data['Size'], pre_data['P50_Tail_Lat_us'], 
            color='blue', alpha=0.5, label='Default Settings')

# Calculate trendline for Pre data
z = np.polyfit(np.log10(pre_data['Size']), pre_data['P50_Tail_Lat_us'], 1)
p = np.poly1d(z)
x_trend = np.logspace(np.log10(pre_data['Size'].min()), 
                      np.log10(pre_data['Size'].max()), 100)
plt.plot(x_trend, p(np.log10(x_trend)), 'b--', alpha=0.8,
         label='Default Trendline')

# Plot Post data points and trendline
post_data = data[data['Type'] == 'Post']
plt.scatter(post_data['Size'], post_data['P50_Tail_Lat_us'], 
            color='green', alpha=0.5, label='Altered Settings')

# Calculate trendline for Post data
z = np.polyfit(np.log10(post_data['Size']), post_data['P50_Tail_Lat_us'], 1)
p = np.poly1d(z)
x_trend = np.logspace(np.log10(post_data['Size'].min()), 
                      np.log10(post_data['Size'].max()), 100)
plt.plot(x_trend, p(np.log10(x_trend)), 'g--', alpha=0.8, 
         label='Altered Trendline')

# Plot MVAPICH data points and trendline
mvapich_data = data[data['Type'] == 'MVAPICH']
plt.scatter(mvapich_data['Size'], mvapich_data['P50_Tail_Lat_us'], 
            color='red', alpha=0.5, label='Altered w/ MVAPICH')

# Calculate trendline for MVAPICH data
z = np.polyfit(np.log10(mvapich_data['Size']), mvapich_data['P50_Tail_Lat_us'], 1)
p = np.poly1d(z)
x_trend = np.logspace(np.log10(mvapich_data['Size'].min()), 
                      np.log10(mvapich_data['Size'].max()), 100)
plt.plot(x_trend, p(np.log10(x_trend)), 'r--', alpha=0.8, 
         label='Altered w/ MVAPICH Trendline')

# Customize the plot
plt.xscale('linear')  # Use log scale for x-axis due to large range
plt.grid(True, which="both", ls="-", alpha=0.2)
plt.xlabel('Packet Size (Bytes)')
plt.ylabel('P50 Tail Latency (μs)')
plt.title('Network Latency Comparison: Default vs Altered vs Altered w/ MVAPICH')
plt.legend()

# Adjust layout and display
plt.tight_layout()
plt.show()
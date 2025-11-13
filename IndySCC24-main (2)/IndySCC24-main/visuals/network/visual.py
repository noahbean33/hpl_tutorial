import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Read the data
data = pd.read_csv('performance-data.csv')

# Create a figure with 2x2 subplots
fig, ((ax1, ax2), (ax3, ax4)) = plt.subplots(2, 2, figsize=(20, 16))

# List of axes and their corresponding metrics
plot_configs = [
    (ax1, 'Avg_Latency_us', 'Average'),
    (ax2, 'P50_Tail_Lat_us', 'P50'),
    (ax3, 'P90_Tail_Lat_us', 'P90'),
    (ax4, 'P99_Tail_Lat_us', 'P99')
]

# Colors and labels
colors = {
    'Pre': 'blue',
    'Post': 'green',
    'MVAPICH': 'red'
}

labels = {
    'Pre': 'Default Settings',
    'Post': 'Altered Settings',
    'MVAPICH': 'Altered w/ MVAPICH'
}

# Create plots for each metric
for ax, metric, title in plot_configs:
    for data_type in ['Pre', 'Post', 'MVAPICH']:
        # Filter data
        type_data = data[data['Type'] == data_type]
        
        # Scatter plot
        ax.scatter(type_data['Size'], type_data[metric],
                  color=colors[data_type], alpha=0.5,
                  label=labels[data_type])
        
        # Calculate and plot trendline
        z = np.polyfit(np.log10(type_data['Size']), type_data[metric], 1)
        p = np.poly1d(z)
        x_trend = np.logspace(np.log10(type_data['Size'].min()),
                            np.log10(type_data['Size'].max()), 100)
        ax.plot(x_trend, p(np.log10(x_trend)),
                '--', color=colors[data_type], alpha=0.8,
                label=f'{labels[data_type]} Trendline')
    
    # Customize each subplot
    ax.set_xscale('linear')
    ax.grid(True, which="both", ls="-", alpha=0.2)
    ax.set_xlabel('Packet Size (Bytes)')
    ax.set_ylabel(f'{title} Latency (μs)')
    ax.set_title(f'{title} Network Latency Comparison')
    ax.legend()

# Add overall title and adjust layout
# fig.suptitle('Network Latency Metrics Comparison: Default vs Altered vs Altered w/ MVAPICH',
#              fontsize=16, y=0.95)
plt.tight_layout()
plt.show()
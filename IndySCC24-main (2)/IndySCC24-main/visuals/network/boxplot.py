import pandas as pd
import numpy as np
from plotnine import *
import matplotlib.pyplot as plt

# Read the CSV file
data = pd.read_csv('performance-data.csv')

# Reshape data for easier plotting
metrics = ['P99_Tail_Lat_us']
melted_data = pd.melt(data, 
                      id_vars=['Size', 'Run', 'Type'],
                      value_vars=metrics,
                      var_name='Metric',
                      value_name='Latency')

# Clean up metric names for display
melted_data['Metric'] = melted_data['Metric'].map({
    'P99_Tail_Lat_us': '99th Percentile Latency',
})

# Map the Type values to new names
melted_data['Type'] = melted_data['Type'].map({
    'Pre': 'Default Network',
    'Post': 'Altered Network',
    'MVAPICH': 'MVAPICH'
})

# Ensure Size is numeric first, then create ordered categories
melted_data['Size'] = pd.to_numeric(melted_data['Size'])
size_order = sorted(melted_data['Size'].unique())
melted_data['Size'] = melted_data['Size'].astype(str)
melted_data['Size'] = pd.Categorical(melted_data['Size'], 
                                    categories=[str(x) for x in size_order],
                                    ordered=True)

# Remove any infinite or NaN values
melted_data = melted_data.replace([np.inf, -np.inf], np.nan).dropna()

# Create the plot
plot = (ggplot(melted_data)
    + aes(x='Size', y='Latency', fill='Type')
    + geom_boxplot(outlier_size=2)
    + facet_wrap('~ Metric', scales='free_y', ncol=2)
    + theme_bw()
    + labs(
        title='Latency Distribution by Message Size and Implementation Type',
        x='Message Size (bytes)',
        y='Latency (microseconds)',
        fill='Implementation Type'
    )
    + theme(
        figure_size=(15, 12),
        plot_title=element_text(size=24, face='bold'),
        axis_title_x=element_text(size=24, face='bold'),
        axis_title_y=element_text(size=24, face='bold'),
        axis_text_x=element_text(size=24, face='bold', rotation=45, hjust=1),
        axis_text_y=element_text(size=24, face='bold'),
        strip_text=element_text(size=20, face='bold'),
        legend_position='right',
        legend_title=element_text(size=24, face='bold'),
        legend_text=element_text(size=24)
    )
    + scale_fill_hue()
)

# Save the plot
plot.save('latency_p99_boxplots.png', dpi=300, verbose=False)

print("Plot saved successfully")
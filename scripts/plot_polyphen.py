import pandas as pd
import matplotlib.pyplot as plt

# read in and prepare Clinvar vs PolyPhen prediction data from `polyphen_analysis.py`
data = pd.read_csv('results/vep/clinvar_group_by_polyphen.csv', index_col=0)
data = data.drop('Excluded')
n = data.sum(axis=1)
proportions = data.div(n, axis=0)

# Make the plot
labels = []
for name, count in zip(n.index, n):
    labels.append(f'{name} (n={count})')

ax = proportions.plot(kind="bar", stacked=True, color=['steelblue', 'orange', 'maroon'])
ax.set_xticklabels(labels, rotation=30, ha='right')
ax.set_ylabel('Proportion of variants')
ax.set_xlabel('ClinVar group')
ax.set_title('PolyPhen predictions by ClinVar group')
ax.legend(title='PolyPhen prediction', bbox_to_anchor=(1.02,0), loc='lower left')

plt.tight_layout()
plt.savefig("figures/PolyPhen_plot.png", bbox_inches='tight', dpi=300)


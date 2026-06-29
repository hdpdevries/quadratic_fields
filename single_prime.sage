import numpy as np
import pandas as pd
import ast 
import matplotlib.pyplot as plt

data = pd.read_table("lmfdb_nf_fields_0513_0806.txt", header=None)

a = Integer(len(data.index))
p = 3 # fixed prime

rank = 0

p_torsion_ranks = []
p_torsion_sizes = []

p_infty_torsion_ranks = []
p_infty_torsion_sizes = []

#p-adic valuation
v = ZZ.valuation(p)

for i in range(a):
    inv = ast.literal_eval((data.iloc[i,1r]))
    p_part = [v(n) for n in inv if v(n) > 0]

    # p-torsion
    rank = len(p_part)
    p_torsion_ranks.append(rank)
    size = p**rank 
    p_torsion_sizes.append(size)

    # p-infty torsion
    rank2 = sum(p_part)
    p_infty_torsion_ranks.append(rank2)
    size2 = p**rank2
    p_infty_torsion_sizes.append(size2)

    # if p_part:
    #     print(f"i: {i} | inv: {inv} | p_part: {p_part} | p-rank: {rank} | p-size: {size} | p-infty rank: {rank2} | p-infty size: {size2}")

df = pd.DataFrame({
    'p_rank': p_torsion_ranks,
    'p_infty rank': p_infty_torsion_ranks
})

df2 = pd.concat([data, df],axis=1)
df2.columns = ["Disc", "Cl_K", "p-torsion rank", "p-infty torsion rank"]


# ===============================
# PLOTTING
# ==============================
p_counts = df2['p-torsion rank'].value_counts()
p_infty_counts = df2['p-infty torsion rank'].value_counts()

all_ranks = sorted(list(set(p_counts.index) | set(p_infty_counts.index)))
df_counts = pd.DataFrame({
    f'{p}-rank': p_counts,
    f'{p}-∞ rank': p_infty_counts
}).reindex(all_ranks).fillna(0

plt.rcParams['figure.figsize'] = [10, 6]

# axes & plot title
ax = df_counts.plot(kind='bar', color=['#1f77b4', '#ff7f0e'], edgecolor='black', width=0.8)
plt.yscale('log')
plt.title(f'Log-Scale Distribution of {p}-rank vs {p}-∞ rank', fontsize=14)
plt.xlabel('Rank Value', fontsize=10)
plt.ylabel('Number of Number Fields (Log Scale)', fontsize=12)
plt.xticks(rotation=0)
plt.grid(axis='y', linestyle='--', alpha=0.3, which='both') 
plt.legend(title='Torsion Type', fontsize=10)

# adding number counts to plot
for container in ax.containers:
    labels = [f'{int(v)}' if v > 0 else '' for v in container.datavalues]
    ax.bar_label(container, labels=labels, label_type='edge', fontweight='bold', padding=3, fontsize=9, rotation=45)

plt.ylim(top=plt.ylim()[1] * 3)

plt.tight_layout()
# plt.savefig(f'rank_distributions_log_for_{p}.png', dpi=300)

plt.show()

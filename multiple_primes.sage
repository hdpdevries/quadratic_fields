import numpy as np
import pandas as pd
import ast 
import matplotlib.pyplot as plt

data = pd.read_table("lmfdb_nf_fields_0513_0806.txt", header=None)

a = Integer(len(data.index))

primes_to_compare = prime_range(1,10)

# list with numberfield, prime, p-rank, p-infty rank
records = []

for i in range(a):
    inv = ast.literal_eval((data.iloc[i, 1r]))  # Safe standard index wrapper
    
    # Loop through each prime for the current field
    for p in primes_to_compare:
        v = ZZ.valuation(p)
        p_part = [v(n) for n in inv if v(n) > 0]
        
        rank = len(p_part)       # p-torsion rank
        rank2 = sum(p_part)      # p-infty torsion rank
        
        records.append({
            'Field_Index': i,
            'Prime': p,
            'p_rank': rank,
            'p_infty_rank': rank2
        })

# Convert all gathered data into a DataFrame
df_multi_prime = pd.DataFrame(records)

# =====================================================================
# Plotting
# =====================================================================

# Group data per prime
counts = df_multi_prime.groupby(['Prime', 'p_rank']).size().unstack(fill_value=int(0))

# bar chart
plt.rcParams['figure.figsize'] = [10, 6]
ax = counts.plot(kind='bar', width=0.8, edgecolor='black', cmap='tab20')

# axes & plot title
plt.title('Comparison of $p$-torsion Ranks Across Various Primes', fontsize=14)
plt.xlabel('Prime ($p$)', fontsize=12)
plt.yscale('log')
plt.ylabel('Number of Number Fields (Log Scale)', fontsize=12)
plt.xticks(rotation=0)  
plt.ylim(bottom=1, top=plt.ylim()[1] * 5)

plt.legend(title='$p$-rank', bbox_to_anchor=(1.02, 1), loc='upper left')
plt.grid(axis='y', linestyle='--', alpha=0.3, which='both')

plt.tight_layout()
plt.show()

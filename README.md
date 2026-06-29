# quadratic_fields
Examining the data of p-torsion of (imaginary) quadratic number fields based on LMFDB

# computing ranks
For each number field K with class group CL_K, write CL_K = prod_{i} (Z/n_{i}Z)

We compute ord_{p}(n_{i}) and create a list [ord_{p}(n_{i}) if ord_{p}(n_{i}) > 0 ]

p-rank: length of list [ord_{p}(n_{i}) if ord_{p}(n_{i}) > 0 ] e.g dim_{F_{p}}(CL_K[p])
p-infty rank: sum of ord_{p}(n_{i}) e.g exponent of p-sylow subgroup of CL_K

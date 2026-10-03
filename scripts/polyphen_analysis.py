import pandas as pd
from scipy.stats import binomtest 

def strip_label(label):
    return label.split('|')[0]

label_groups = {
    'Benign': 'Benign/Likely_benign',
    'Benign/Likely_benign': 'Benign/Likely_benign',
    'Conflicting_classifications_of_pathogenicity': 'Conflict',
    'Likely_benign': 'Benign/Likely_benign',
    'Likely_pathogenic': 'Pathogenic/Likely_pathogenic',
    'Pathogenic': 'Pathogenic/Likely_pathogenic',
    'Pathogenic/Likely_pathogenic': 'Pathogenic/Likely_pathogenic',
    'Uncertain_significance': 'VUS',
}

def check_label(label):
    if not pd.isna(label):
        label = strip_label(label)
    group = label_groups.get(label, 'Excluded')
    return group

    
rows = []
with open('results/vep/clinvar_hexa.chr15.vep.vcf') as f:
    for line in f:
        if line.startswith('#'):
            continue
        info = line.split('\t')[7]
        clnsig = None
        csq = None
        for field in info.split(';'):
            if field.startswith('CLNSIG='):
                clnsig = field.split('=')[1]
            if field.startswith('CSQ='):
                csq = field.split('=')[1]
        if csq is None:
            continue
        best = None
        for annotation in csq.split(','):
            parts = annotation.split('|')
            if 'missense_variant' in parts[1] and parts[39] and parts[39] != 'unknown(0)':
                best = parts[39]
                break
        if best:
            rows.append({'clnsig': clnsig, 'polyphen': best})

df = pd.DataFrame(rows)
print(len(df))
print(df.head())
print(df['polyphen'].value_counts())
df['polyphen_class'] = df['polyphen'].str.split('(').str[0]
df['group'] = df['clnsig'].apply(check_label)
print(pd.crosstab(df['group'], df['polyphen_class'], margins=True))
print(pd.crosstab(df['clnsig'], df['polyphen_class'], margins=True))

intervals = [('lenient sensitivity', 57, 77), 
             ('strict sensitivity', 45, 77), 
             ('lenient specificity', 36, 41), 
             ('strict specificity', 39, 41)]

for frac in intervals:
    result = binomtest(frac[1], frac[2])
    ci = result.proportion_ci(method='wilson')
    print(f'{frac[0]} point estimate: {frac[1]/frac[2]:.3f} confidence interval (Wilson):  (95% {ci.low:.3f} - {ci.high:.3f})')
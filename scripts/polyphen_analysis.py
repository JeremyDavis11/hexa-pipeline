import pandas as pd

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
print(pd.crosstab(df['clnsig'], df['polyphen_class']))
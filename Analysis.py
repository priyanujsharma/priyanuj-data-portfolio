# ---import required libraries---
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

#---set plotting aesthetics---
sns.set(style='whitegrid')

#---loading dataset---
df = pd.read_csv("India School Education Dataset/Cleaned/education_master_table.csv")

# ---basic exploration and datset preparation---

# - view top rows
print(df.head())
# - shape of dataset
print('Shape:', df.shape)
# - data types and non-null counts
print(df.info())
# - summary statistics for numerical columns
print(df.describe())
# - check null counts by column
print(df.isnull().sum().sort_values(ascending=False))
# - create working copy
df_main = df.copy()
# - prepare dropout subset (non-null dropout indicators)
df_dropout = df_main.dropna(subset=['Primary_Total', 'Upper_Primary_Total', 'Secondary_Total', 
    'HrSecondary_Total'])
# - prepare subset for correlation analysis
infra_cols = ['Schools_With_Boys_Toilet', 'Schools_With_Girls_Toilet', 'Schools_With_Computer', 
    'Schools_With_Electricity', 'Schools_With_Water']
outcome_cols = ['Primary_Total', 'GER_Primary_Total', 'Upper_Primary_Total', 'GER_Upper_Primary_Total',
    'Secondary_Total', 'GER_Secondary_Total', 'HrSecondary_Total', 'GER_HrSecondary_Total']
df_corr = df_main.dropna(subset=infra_cols + outcome_cols)

# ---exploratory data analysis---

# 1 - national-level dropout trends over time
# - average dropout rates by year across the country
national_dropout_yearly = df_dropout.groupby('Year')[['Primary_Total', 'Upper_Primary_Total', 
    'Secondary_Total', 'HrSecondary_Total']].mean()
# - plotting dropout trends over time
plt.figure(figsize=(12, 6))
plt.plot(national_dropout_yearly.index, national_dropout_yearly['Primary_Total'], marker='o', label='Primary')
plt.plot(national_dropout_yearly.index, national_dropout_yearly['Upper_Primary_Total'], marker='o', label='Upper Primary')
plt.plot(national_dropout_yearly.index, national_dropout_yearly['Secondary_Total'], marker='o', label='Secondary')
plt.plot(national_dropout_yearly.index, national_dropout_yearly['HrSecondary_Total'], marker='o', label='Hr Secondary')
plt.title('Average Dropout Rate by Year (National Level)')
plt.ylabel('Dropout Rate (%)')
plt.xlabel('Academic Year')
plt.legend()
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

# 2 - national-level ger trends over time
# - average ger by year across the country
ger_national_yearly = df_dropout.groupby('Year')[['GER_Primary_Total', 'GER_Upper_Primary_Total', 
    'GER_Secondary_Total', 'GER_HrSecondary_Total']].mean()
# - plotting ger trends over time
plt.figure(figsize=(12, 6))
plt.plot(ger_national_yearly.index, ger_national_yearly['GER_Primary_Total'], marker='o', label='Primary')
plt.plot(ger_national_yearly.index, ger_national_yearly['GER_Upper_Primary_Total'], marker='o', label='Upper Primary')
plt.plot(ger_national_yearly.index, ger_national_yearly['GER_Secondary_Total'], marker='o', label='Secondary')
plt.plot(ger_national_yearly.index, ger_national_yearly['GER_HrSecondary_Total'], marker='o', label='Hr Secondary')
plt.title('Average GER by Year (National Level)')
plt.ylabel('Gross Enrollment Ratio (%)')
plt.xlabel('Academic Year')
plt.legend()
plt.xticks(rotation=45)
plt.tight_layout()
plt.show()

# 3 - correlation analysis: school infrastructure vs education outcomes
# - compute correlation matrix
corr_matrix = df_corr[infra_cols + outcome_cols].corr()
# plotting heatmap
plt.figure(figsize=(14, 8))
sns.heatmap(corr_matrix, annot=True, fmt='.2f', cmap='coolwarm')
plt.title('Correlation Between School Infrastructure and Educational Outcomes (National Level)')
plt.xticks(rotation=45, ha='right')
plt.yticks(rotation=0)
plt.tight_layout()
plt.show()

# 4 - state-wise dropout analysis
# - view top 5 and bottom 5 states by average dropout rate across grades over time
state_dropout = df_dropout.groupby('State_UT')[['Primary_Total', 'Upper_Primary_Total', 'Secondary_Total', 
    'HrSecondary_Total']].mean()
state_dropout['Avg_Dropout'] = state_dropout.mean(axis=1)
state_dropout_sorted = state_dropout.sort_values('Avg_Dropout', ascending=False)
print("Top 5 States with Highest Average Dropout:\n", state_dropout_sorted.head(5))
print("\nBottom 5 States with Lowest Average Dropout:\n", state_dropout_sorted.tail(5))

# 5 - state-wise GER analysis
# - view top 5 and bottom 5 states by average GER across grades over time
state_ger = df_dropout.groupby('State_UT')[['GER_Primary_Total', 'GER_Upper_Primary_Total', 
    'GER_Secondary_Total', 'GER_HrSecondary_Total']].mean()
state_ger['Avg_GER'] = state_ger.mean(axis=1)
state_ger_sorted = state_ger.sort_values('Avg_GER', ascending=False)
print("Top 5 States with Highest Average GER:\n", state_ger_sorted.head(5))
print("\nBottom 5 States with Lowest Average GER:\n", state_ger_sorted.tail(5))

# 6 - infrastructure comparison: national vs top/bottom states
# - calculate average infrastructure access for top 5 dropout states, bottom 5 dropout states,
top5_dropout_states = state_dropout_sorted.head(5).index.tolist()
bottom5_dropout_states = state_dropout_sorted.tail(5).index.tolist()
top5_ger_states = state_ger_sorted.head(5).index.tolist()
bottom5_ger_states = state_ger_sorted.tail(5).index.tolist()
national_infra_avg = df_corr[infra_cols].mean()
infra_top5_dropout = df_corr[df_corr['State_UT'].isin(top5_dropout_states)][infra_cols].mean()
infra_bottom5_dropout = df_corr[df_corr['State_UT'].isin(bottom5_dropout_states)][infra_cols].mean()
infra_top5_ger = df_corr[df_corr['State_UT'].isin(top5_ger_states)][infra_cols].mean()
infra_bottom5_ger = df_corr[df_corr['State_UT'].isin(bottom5_ger_states)][infra_cols].mean()

infra_comparison = pd.DataFrame({
    'National Average': national_infra_avg,
    'Top 5 Dropout States': infra_top5_dropout,
    'Bottom 5 Dropout States': infra_bottom5_dropout,
    'Top 5 GER States': infra_top5_ger,
    'Bottom 5 GER States': infra_bottom5_ger
})

# - plotting bar chart for infrastructure comparison
ax = infra_comparison.plot(kind='bar', figsize=(14, 7), rot=45)
plt.title('School Infrastructure Comparison: National vs State Groups')
plt.ylabel('Average % of Schools with Facility')
for container in ax.containers:
    ax.bar_label(container, fmt='%.1f', label_type='edge', fontsize=8, padding=2)
plt.tight_layout()
plt.show()
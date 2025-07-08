# Evaluating the Impact of School Infrastructure on Student Retention & Enrollment

## 🧭 Overview

This project explores the relationship between school infrastructure and educational outcomes in India, with a focus on dropout rates and Gross Enrollment Ratio (GER) across states and school levels from 2012 to 2016. Using a clean, consolidated dataset derived from multiple government sources, it investigates how access to basic facilities like toilets, water, electricity, and computers influences student retention and participation.

📊 Through structured analysis, the project aims to uncover actionable patterns that can inform policies focused on improving learning conditions and reducing school dropouts.

**Data Source:**  
Indian School Education Statistics - [Kaggle Dataset](https://www.kaggle.com/datasets/vidyapb/indian-school-education-statistics)

---

## 🎯 Objectives

- Understand national and state-level trends in dropout rates and GER across Primary, Upper Primary, Secondary, and Higher Secondary levels.
- Assess the correlation between school infrastructure (toilets, water, electricity, computers) and educational outcomes.
- Identify infrastructural gaps in high-dropout regions and highlight best-performing states in terms of both GER and infrastructure coverage.
- Provide clear visualizations and interpretations to communicate insights effectively.

---

## ⚙️ Methodology

The project involved two major phases:

### 📂 Data Cleaning & Integration (SQL)

- **Standardization**: Unified inconsistent column names, formats, and state names across 7 datasets.
- **Missing Value Imputation**: Imputed sparse nulls using national yearly averages to preserve trend fidelity.
- **Duplicate Checks**: Ensured no duplication of state–year entries.
- **Master Table Creation**: Merged dropout, GER, and infrastructure datasets using SQL joins on `State_UT` and `Year`, yielding a final consolidated table ready for EDA.
- **Export**: Cleaned and structured tables exported as `.csv` files for analysis.

### 📈 Exploratory Analysis (Python)

- Used `Pandas`, `Matplotlib`, and `Seaborn` for descriptive stats and visualization.
- Explored:
  - National-level dropout and GER trends over time
  - Correlation matrix between infrastructure and outcomes
  - State-wise ranking by dropout and GER
  - Bar plots comparing infrastructure availability in top/bottom states
- Created separate filtered datasets for correlation reliability.

---

## 🧮 MIS Dashboard

An interactive MIS Dashboard (`MIS Dashboard.xlsm`) is included for structured review of state-level dropout, GER, and infrastructure data. This macro-enabled Excel tool allows for:

- Dynamic filtering by State/UT and academic year.
- Side-by-side comparison of infrastructure metrics and education outcomes.
- Quick visual cues for identifying high-risk or high-performing regions.

It serves as a user-friendly, shareable output for policy teams or non-technical stakeholders.

---

## 🗂️ Project Structure

📁 Priyanuj-Data-Portfolio/  
├── 📄 README.md  
├── 📁 Datasets/  
│   ├── 📁 Raw/  
│   └── 📁 Cleaned/  
├── 📄 Data_Preprocessing.sql  
├── 📄 Analysis.py  
├── 📁 Insights & Visualizations/  
│   ├── 📄 Insights & Summary.md  
│   ├── 📄 Average Dropout by Year.png  
│   ├── 📄 Average GER by Year.png  
│   ├── 📄 Correlation Between School Infrastructure and Educational Outcomes.png  
│   └── 📄 School Infrastructure Comparison_National vs State Groups.png  
└── 📄 MIS Dashboard.xlsm  


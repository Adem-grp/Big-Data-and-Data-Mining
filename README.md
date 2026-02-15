# Clinical Data Mining: Predicting Asthma Worsening

## Project Overview
This project involves a comprehensive end-to-end clinical data science pipeline. It covers the extraction and cleaning of large-scale healthcare data using **Oracle SQL** and the development of predictive models using **MATLAB** to identify patients at risk of worsened asthma.

## 1. Data Engineering (Oracle SQL)
The raw dataset was processed to ensure clinical validity and SNOMED-CT compliance.
* **Data Cleaning**: Standardized gender codes ('M', 'F', 'U') and converted string dates into Oracle `DATE` formats for longitudinal analysis.
* **Feature Engineering**:
    * **Clinical Flags**: Created binary indicators for Diabetes, Smoking, and Hypertension based on medical diagnosis codes.
    * **Pulse Pressure**: Derived by calculating the difference between the most recent Systolic and Diastolic blood pressure readings ($Pulse\ Pressure = SBP - DBP$).
    * **Motorway Proximity**: Grouped distances into categorical intervals (`<0.5km`, `0.5-1km`, `1-5km`, `>5km`) to analyze environmental stressors.
    * **Risk Count**: Aggregated comorbidities (Smoking + Diabetes + Hypertension + etc.) into a "Risk Count" feature.
* **Pipeline Optimization**: Utilized **Common Table Expressions (CTEs)** to create a final, optimized table containing demographic, lipid, and blood pressure profiles.

## 2. Exploratory Data Analysis (MATLAB)
Statistical analysis was performed to validate clinical hypotheses:
* **Prevalence**: Confirmed that approximately **14.1%** of patients experienced worsened asthma.
* **Age & Environment**: Visualized high prevalence rates in specific age groups and among patients living closer to motorways.
* **Correlation**: Heatmaps revealed relationships between family history, diabetes, and asthma worsening.



## 3. Machine Learning & Predictive Modeling
Three classification models were developed to predict the target: `asthma_worsened`. 

### Handling Imbalanced Data
To prioritize finding high-risk patients (optimizing **Recall**) over simple accuracy, the following techniques were applied:
* **Weighted Logistic Regression**: Applied a **3.5x weight** to positive cases to force the model to focus on high-risk patients.
* **Decision Tree**: Used a `uniform` prior distribution to balance class importance despite unequal sample sizes.
* **Random Forest (TreeBagger)**: Implemented a **Cost Matrix** where False Negatives (missing a high-risk patient) cost **3.5x more** than False Positives.

## 4. Model Evaluation
The models were evaluated using confusion matrices and ROC/AUC curves.

| Model | Technique | Key Strength |
| :--- | :--- | :--- |
| **Logistic Regression** | Weighted GLM | Highest Recall; best for clinical screening. |
| **Decision Tree** | Uniform Prior | Best for interpretability and visualizing decision paths. |
| **Random Forest** | Cost Matrix | Robust performance; identifies key predictors like Pulse Pressure. |



## 5. Key Clinical Findings
* **Predictor Importance**: **Pulse Pressure**, **Risk Count**, and **Hypertension** emerged as the strongest predictors across all models.
* **Actionable Insight**: Patients with high Pulse Pressure and multiple comorbidities show a significantly higher probability of asthma worsening, suggesting a need for more aggressive monitoring in primary care.

## Technologies Used
* **Database**: Oracle SQL (CTEs, DDL, DML, SNOMED-CT Mapping).
* **Programming**: MATLAB (Statistics and Machine Learning Toolbox).
* **Modeling**: Logistic Regression, Decision Trees, Random Forest (TreeBagger).

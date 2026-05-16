SELECT * FROM CW; 
CREATE TABLE CW_MODIFIED AS SELECT * FROM CW; 
-- initial data understanding 
SELECT column_name,data_type FROM user_tab_columns WHERE table_name= 'CW';

SELECT * FROM CW WHERE patient_id is NULL;
SELECT * FROM CW WHERE year_of_birth is NULL;
WITH gender_distribution AS(
    SELECT gender, COUNT(*),ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM CW GROUP BY gender
) SELECT * FROM gender_distribution;

-- there are no outliers for year of birth column
SELECT * FROM CW WHERE year_of_birth >=2026;
SELECT * FROM CW WHERE year_of_birth <= 1916;

-- there are 6 options for gender we need to clean that according to snomed codes 
SELECT sys_code1,COUNT(*), ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM CW GROUP BY sys_code1;
SELECT sys_code2,COUNT(*), ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM CW GROUP BY sys_code2;
--  no missing values for sys codes 
SELECT dias_code1,COUNT(*), ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM CW GROUP BY dias_code1;
SELECT dias_code2,COUNT(*), ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM CW GROUP BY dias_code2;
-- no missing values for dias codes as well 
SELECT chltot_code1,COUNT(*), ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM CW GROUP BY chltot_code1;
SELECT chltot_code2,COUNT(*), ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM CW GROUP BY chltot_code2;
SELECT chlhdl_code1,COUNT(*), ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM CW GROUP BY chlhdl_code1;
SELECT chlhdl_code2,COUNT(*), ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM CW GROUP BY chlhdl_code2;
SELECT diab_code1,COUNT(*), ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM CW GROUP BY diab_code1;
SELECT smok_code1,COUNT(*), ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM CW GROUP BY smok_code1;
SELECT cvdrx_code1,COUNT(*), ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM CW GROUP BY cvdrx_code1;
SELECT fh_asthma_code1,COUNT(*), ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM CW GROUP BY fh_asthma_code1;


-- checking value ranges
SELECT MIN(sys_val1) as min_sys_val1,MAX(sys_val1) as max_sys_val1,ROUND(AVG(sys_val1),2) as avg_sys_val1,MIN(sys_val2) as min_sys_val2,MAX(sys_val2) as max_sys_val2,ROUND(AVG(sys_val2),2) as avg_sys_val2 FROM CW;
-- checking null count and its percentage
SELECT SUM(CASE WHEN sys_val1 is NULL THEN 1 ELSE 0 END) as sys1_null_count ,ROUND(SUM(CASE WHEN sys_val1 IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS sys1_null_percentage,
SUM(CASE WHEN sys_val2 is NULL THEN 1 ELSE 0 END) as sys2_null_count ,ROUND(SUM(CASE WHEN sys_val2 IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS sys2_null_percentage FROM CW;

SELECT MIN(dias_val1) as min_dias_val1,MAX(dias_val1) as max_dias_val1,ROUND(AVG(dias_val1),2) as avg_dias_val1,MIN(dias_val2) as min_dias_val2,MAX(dias_val2) as max_dias_val2,ROUND(AVG(dias_val2),2) as avg_dias_val2 FROM CW;
-- both dias and sys values are within acceptable ranges and stays away from edge cases.
SELECT SUM(CASE WHEN dias_val1 is NULL THEN 1 ELSE 0 END) as dias1_null_count ,ROUND(SUM(CASE WHEN dias_val1 IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS dias1_null_percentage,
SUM(CASE WHEN dias_val2 is NULL THEN 1 ELSE 0 END) as dias2_null_count ,ROUND(SUM(CASE WHEN dias_val2 IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS dias2_null_percentage FROM CW;

SELECT MIN(chlhdl_val1) as min_chlhdl_val1,MAX(chlhdl_val1) as max_chlhdl_val1,ROUND(AVG(chlhdl_val1),2) as avg_chlhdl_val1,MIN(chlhdl_val2) as min_chlhdl_val2,MAX(chlhdl_val2) as max_chlhdl_val2,ROUND(AVG(chlhdl_val2),2) as avg_chlhdl_val2 FROM CW;

SELECT SUM(CASE WHEN chlhdl_val1 is NULL THEN 1 ELSE 0 END) as chlhdl1_null_count ,ROUND(SUM(CASE WHEN chlhdl_val1 IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS chlhdl1_null_percentage,
SUM(CASE WHEN chlhdl_val2 is NULL THEN 1 ELSE 0 END) as chlhdl2_null_count ,ROUND(SUM(CASE WHEN chlhdl_val2 IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS chlhdl2_null_percentage FROM CW;


--  the range of values and averages of chltot values 
SELECT MIN(chltot_val1) as min_chltot_val1,MAX(chltot_val1) as max_chltot_val1,ROUND(AVG(chltot_val1),2) as avg_chltot_val1,MIN(chltot_val2) as min_chltot_val2,MAX(chltot_val2) as max_chltot_val2,ROUND(AVG(chltot_val2),2) as avg_chltot_val2 FROM CW;

SELECT SUM(CASE WHEN chltot_val1 is NULL THEN 1 ELSE 0 END) as chltot1_null_count ,ROUND(SUM(CASE WHEN chltot_val1 IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS chltot1_null_percentage,
SUM(CASE WHEN chltot_val2 is NULL THEN 1 ELSE 0 END) as chltot2_null_count ,ROUND(SUM(CASE WHEN chltot_val2 IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS chltot2_null_percentage FROM CW;

SELECT  * FROM CW WHERE mwaydist_km1<0;
-- no negative distance values
SELECT SUM(CASE WHEN mwaydist_km1 is NULL THEN 1 ELSE 0 END) as mway_null_count ,ROUND(SUM(CASE WHEN mwaydist_km1 IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS mway_null_percentage FROM CW;
-- 991 null values for mwaydist_km1 
-- distribution of mwaydist_km1 values and its average 
SELECT MIN(mwaydist_km1) as min_mwaydist_km1,MAX(mwaydist_km1) as max_mwaydist_km1,ROUND(AVG(mwaydist_km1),2) as avg_mwaydist_km1 FROM CW;






SELECT DISTINCT (SELECT COUNT(*) FROM CW WHERE chlhdl_val1<=0) as val1_outliers,(SELECT COUNT(*) FROM CW WHERE chlhdl_val2<=0) as val2_outliers FROM CW;
-- there are no values for chlhdl_val1 <=0 and there are 223 values for chldl_val2 <= 0 
-- so we will need to set 223 values to null because of chldl_val2 has 223 placeholder values since those values cannot be zero or under zero unless the patient is dead

SELECT COUNT(chltot_val1) as val1_outliers FROM CW WHERE chltot_val1<2 or chltot_val1 >10;
-- there are no outliers for chltot_val1
SELECT COUNT(chltot_val2) as val2_outliers FROM CW WHERE chltot_val2<2 or chltot_val1 >10;
-- there are 153 outliers for chltot_val2



SELECT asthma_worsened,COUNT(*) AS num_patients, ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM CW GROUP BY asthma_worsened;
-- there are 1410 cases where asthma is worsened in this dataset (14.1%)





SELECT * FROM CW_MODIFIED;

-- data preparation 
-- gender cleaning and categorisation
UPDATE  CW_MODIFIED SET 
gender= CASE gender
    WHEN '446141000124107' THEN 'M'
    WHEN '446151000124109' THEN 'F'
    WHEN 'M' THEN 'M'
    WHEN 'F' THEN 'F'
    ELSE 'U'
    END;


SELECT gender,COUNT(*) AS freq, ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM CW_MODIFIED GROUP BY gender;
-- no need to drop unknowns, they can be utilised



ALTER TABLE CW_MODIFIED ADD (patient_age_group NUMBER);
UPDATE CW_MODIFIED SET patient_age_group = FLOOR((EXTRACT(YEAR FROM SYSDATE) - Year_of_Birth)/10)*10;
-- created an age column from year_of_birth for simplicity in 10 year intervals
SELECT patient_age_group,COUNT(*) FROM CW_MODIFIED GROUP BY patient_age_group;


-- changing varchar to date 
SELECT chltot_date1,chltot_date2 FROM CW_MODIFIED WHERE chltot_date1 is not NULL; 
-- format: year-month-day for chltot_date1 and chltot_date2 
SELECT diab_date1 FROM CW_MODIFIED WHERE diab_date1 is not NULL;
-- format: year-month-day for diab_date1
SELECT smok_date1 FROM CW_MODIFIED WHERE smok_date1 is not NULL;
-- format: year-month-day 
SELECT cvdrx_date1 FROM CW_MODIFIED WHERE cvdrx_date1 is not NULL;
-- format: year-month-day 
SELECT fh_asthma_date1 FROM CW_MODIFIED WHERE fh_asthma_date1 is not NULL;
-- format: year-month-day 
ALTER TABLE CW_MODIFIED ADD(chltot_date1_dt DATE, chltot_date2_dt DATE, diab_date1_dt DATE, smok_date1_dt DATE,cvdrx_date1_dt DATE, fh_asthma_date1_dt DATE);
-- in order to not destroy data for now I decided to add new date columns these clean columns will be used
-- and if there is no problems occurring it is possible to delete the old columns 

UPDATE CW_MODIFIED SET chltot_date1_dt = CASE WHEN chltot_date1 is NULL or TRIM(chltot_date1) ='' THEN NULL ELSE TO_DATE(chltot_date1,'YYYY-MM-DD') END;
UPDATE CW_MODIFIED SET chltot_date2_dt = CASE WHEN chltot_date2 is NULL or TRIM(chltot_date2) ='' THEN NULL ELSE TO_DATE(chltot_date2,'YYYY-MM-DD') END;
UPDATE CW_MODIFIED SET diab_date1_dt = CASE WHEN diab_date1 is NULL or TRIM(diab_date1) ='' THEN NULL ELSE TO_DATE(diab_date1,'YYYY-MM-DD') END;
UPDATE CW_MODIFIED SET smok_date1_dt = CASE WHEN smok_date1 is NULL or TRIM(smok_date1) ='' THEN NULL ELSE TO_DATE(smok_date1,'YYYY-MM-DD') END;
UPDATE CW_MODIFIED SET cvdrx_date1_dt = CASE WHEN cvdrx_date1 is NULL or TRIM(cvdrx_date1) ='' THEN NULL ELSE TO_DATE(cvdrx_date1,'YYYY-MM-DD') END;
UPDATE CW_MODIFIED SET fh_asthma_date1_dt = CASE WHEN fh_asthma_date1 is NULL or TRIM(fh_asthma_date1) ='' THEN NULL ELSE TO_DATE(fh_asthma_date1,'YYYY-MM-DD') END;
-- now we have proper date columns for each one
-- checking if there are null values that escaped the conversion  
SELECT COUNT(chltot_date1),COUNT(chltot_date1_dt) FROM CW_MODIFIED WHERE chltot_date1 is not NULL AND chltot_date1_dt is not NULL;
SELECT COUNT(chltot_date2),COUNT(chltot_date2_dt) FROM CW_MODIFIED WHERE chltot_date2 is not NULL AND chltot_date2_dt is not NULL;
SELECT COUNT(diab_date1),COUNT(diab_date1_dt) FROM CW_MODIFIED WHERE diab_date1 is not NULL AND diab_date1_dt is not NULL;
SELECT COUNT(smok_date1),COUNT(smok_date1_dt) FROM CW_MODIFIED WHERE smok_date1 is not NULL AND smok_date1_dt is not NULL;
SELECT COUNT(cvdrx_date1),COUNT(cvdrx_date1_dt) FROM CW_MODIFIED WHERE cvdrx_date1 is not NULL AND cvdrx_date1_dt is not NULL;
SELECT COUNT(fh_asthma_date1),COUNT(fh_asthma_date1_dt) FROM CW_MODIFIED WHERE fh_asthma_date1 is not NULL AND fh_asthma_date1_dt is not NULL;
ALTER TABLE CW_MODIFIED DROP(chltot_date1,chltot_date2,diab_date1,smok_date1,cvdrx_date1,fh_asthma_date1);

-- add have_chltot and have_chlhdl flag
ALTER TABLE CW_MODIFIED ADD(have_chltot NUMBER(1), have_chlhdl NUMBER(1));
-- assign valid codes as 1 else 0 
UPDATE CW_MODIFIED SET have_chltot = CASE WHEN chltot_code1 ='853681000000104' OR chltot_code2 ='853681000000104' THEN 1 ELSE 0 END;
UPDATE CW_MODIFIED SET have_chlhdl = CASE WHEN chlhdl_code1 ='1005681000000107' OR chlhdl_code2 ='1005681000000107' THEN 1 ELSE 0 END;

SELECT have_chltot,have_chlhdl FROM CW_MODIFIED;


-- creating have_diabetes column to identify the patients with diabetes more efficiently 
-- the column will have boolean either 1 (have diabetes diagnosis) or 0(do not have one)
ALTER TABLE CW_MODIFIED ADD(have_diabetes NUMBER(1));

-- setting valid codes as 1 and others as 0 for simplicity
-- only confirmed valid data will be identified as 1 null values can be assigned as 0s since there is no evidence saying that they have diabetes
-- this approach will be applied to all flags as asthma_worsened column do not contain any null values

UPDATE CW_MODIFIED SET 
 have_diabetes= CASE WHEN diab_code1 IN ('44054006','111552007','237599002','73211009') THEN 1 ELSE 0 END;

SELECT have_diabetes FROM CW_MODIFIED;

SELECT * FROM CW_MODIFIED;
-- continued with checking for smoking as well if person smokes 1 else 0 for is_smoking column 
ALTER TABLE CW_MODIFIED ADD(is_smoking NUMBER(1));

UPDATE CW_MODIFIED SET 
is_smoking = CASE WHEN smok_code1 IN('230056004','230057008','230058003','266920004') THEN 1 ELSE 0 END;
SELECT is_smoking FROM CW_MODIFIED;

-- on_bp_meds, have_fh_asthma will be created from cvdrx and fh_asthma codes

ALTER TABLE CW_MODIFIED ADD(on_bp_meds NUMBER(1));
UPDATE CW_MODIFIED SET 
on_bp_meds = CASE WHEN  cvdrx_code1 IN('6131004','372727001','11000132102','11000129103','1040010010001002','111708003','
372729009','324121000000109','11560009') THEN 1 ELSE 0 END;
SELECT on_bp_meds FROM CW_MODIFIED;
-- creating a column to see if someone has asthma_fh 
ALTER TABLE CW_MODIFIED ADD(have_fh_asthma NUMBER(1));
UPDATE CW_MODIFIED SET 
have_fh_asthma= CASE WHEN fh_asthma_code1 ='160357008' THEN 1 ELSE 0 END;
SELECT have_fh_asthma FROM CW_MODIFIED;

SELECT patient_id, COUNT(*) as record_count FROM CW GROUP BY patient_id HAVING COUNT(*) > 1;
-- cross sectional dataset symptom frequency should be calculated as risk count


-- chlhdl and chltot cleaning invalids and outliers 
UPDATE CW_MODIFIED SET chlhdl_val2 = CASE WHEN chlhdl_val2 <=0 THEN NULL ELSE chlhdl_val2 END;
SELECT chlhdl_val2 FROM CW_MODIFIED WHERE chlhdl_val2<=0;

UPDATE CW_MODIFIED SET chltot_val2 = CASE WHEN chltot_val2<2 OR chltot_val2 >10 THEN NULL ELSE chltot_val2 END;

UPDATE CW_MODIFIED SET chlhdl_val1 = CASE WHEN chlhdl_val1 <=0 THEN NULL ELSE chlhdl_val1 END;

UPDATE CW_MODIFIED SET chltot_val1 = CASE WHEN chltot_val1<2 OR chltot_val1 >10 THEN NULL ELSE chltot_val1 END;

SELECT mwaydist_km1,mwaydist_date1 FROM CW_MODIFIED;

--mwaydist_km1 needs to be grouped to reduce noise and measure the effects more clearly

ALTER TABLE CW_MODIFIED ADD(mwaydist_interval VARCHAR2(4000 BYTE));
-- with these intervals I tried to group according to short,medium and large distance

UPDATE CW_MODIFIED SET mwaydist_interval =
CASE WHEN mwaydist_km1<=0.5 THEN '<0.5km'
WHEN mwaydist_km1>0.5 AND mwaydist_km1<=1.0 THEN '0.5-1km'
WHEN mwaydist_km1>1.0 AND mwaydist_km1<=5.0 THEN '1-5km'
ELSE '>5km'  
END;
-- there are  only 991 null values for simplicity we can put them to the least exposure category.
SELECT mwaydist_interval,COUNT(*) AS number_dist FROM CW_MODIFIED GROUP BY mwaydist_interval ORDER BY number_dist DESC;
-- clustering the cleaned data with CTEs


-- explanation for the CTEs since adding comment between them creates errors, it was written as block comment section.

-- instead of CREATE VIEW, CREATE TABLE was used.
-- first cleared the systolic and diastolic values by validating their codes
-- then found the most recent values to derive pulse pressure
-- same steps were taken for chltot and chlhdl validated through SNOMED codes
-- then found the recent values 
-- afterwards, tc_hdl_ratio was created.
-- Note: for the tc_hdl_ratio after seeing that there are too many null values, it was not used in training since it would introduce bias 
CREATE TABLE final_table AS
WITH systolic_clean AS(
    SELECT patient_id,bp_date1,bp_date2,
    CASE WHEN sys_code1=271649006 THEN sys_val1 END AS sbp1,
    CASE WHEN sys_code2=271649006 THEN sys_val2 END AS sbp2 FROM CW_MODIFIED
),
diastolic_clean AS(
    SELECT patient_id,bp_date1,bp_date2,
    CASE WHEN dias_code1=271650006 THEN dias_val1 END AS dbp1,
    CASE WHEN dias_code2=271650006 THEN dias_val2 END AS dbp2 FROM CW_MODIFIED
),
bp_clean AS(
    SELECT s.patient_id,s.bp_date1,s.bp_date2,s.sbp1,s.sbp2,d.dbp1,d.dbp2 FROM systolic_clean s JOIN diastolic_clean d ON s.patient_id=d.patient_id
),
bp_features AS(
    SELECT patient_id, CASE WHEN bp_date1 >=bp_date2 THEN sbp1 ELSE sbp2 END AS recent_sbp,
    CASE WHEN bp_date1 >=bp_date2 THEN dbp1 ELSE dbp2 END AS recent_dbp FROM bp_clean 
),
bp_derived AS(
    SELECT patient_id,recent_sbp,recent_dbp,
    CASE WHEN recent_sbp is not NULL AND recent_dbp  is not NULL THEN (recent_sbp-recent_dbp) END AS pulse_pressure, 
    CASE WHEN recent_sbp >=140 OR recent_dbp >=90 THEN 1 ELSE 0 END AS hypertension
    FROM bp_features
),
chlhdl_clean AS(
    SELECT patient_id,chlhdl_date1,chlhdl_date2, 
    CASE WHEN chlhdl_code1=1005681000000107 THEN chlhdl_val1 END AS chlhdl1,
    CASE WHEN chlhdl_code2=1005681000000107 THEN chlhdl_val2 END AS chlhdl2 FROM CW_MODIFIED
),
chltot_clean AS(
    SELECT patient_id,chltot_date1_dt,chltot_date2_dt,
    CASE WHEN chltot_code1 =853681000000104 THEN chltot_val1 END AS chltot1,
    CASE WHEN chltot_code2 =853681000000104 THEN chltot_val2 END AS chltot2 FROM CW_MODIFIED
),
Lipid_Profile_clean AS(
    SELECT hdl.patient_id,hdl.chlhdl_date1,hdl.chlhdl_date2,hdl.chlhdl1,hdl.chlhdl2, tot.chltot_date1_dt,tot.chltot_date2_dt,
    tot.chltot1,tot.chltot2 FROM chlhdl_clean hdl JOIN chltot_clean tot ON hdl.patient_id=tot.patient_id
),
Lipid_Profile_recent AS(
    SELECT patient_id, CASE WHEN chlhdl_date1 >= chlhdl_date2 THEN chlhdl1 ELSE chlhdl2 END AS recent_chlhdl,
    CASE WHEN chltot_date1_dt >= chltot_date2_dt THEN chltot1 ELSE chltot2 END AS recent_chltot FROM Lipid_Profile_clean 
),
Tc_Hdl_Ratio AS(
    SELECT patient_id,recent_chlhdl,recent_chltot, CASE WHEN recent_chlhdl>0 AND recent_chlhdl is not NULL AND recent_chltot is not NULL
    THEN (recent_chltot/recent_chlhdl) END AS tc_hdl_ratio FROM Lipid_Profile_recent
),
demographic_flags AS(
    SELECT patient_id,gender,patient_age_group,is_smoking,have_diabetes,on_bp_meds,have_fh_asthma,asthma_worsened,mwaydist_interval,have_chlhdl,have_chltot FROM CW_MODIFIED
) SELECT d.patient_id,d.gender,d.patient_age_group,d.is_smoking,d.have_diabetes,d.on_bp_meds,d.have_fh_asthma,d.asthma_worsened,d.mwaydist_interval,d.have_chlhdl,d.have_chltot,
bd.recent_sbp,bd.recent_dbp,bd.pulse_pressure,bd.hypertension,ld.recent_chlhdl,ld.recent_chltot,ld.tc_hdl_ratio
FROM demographic_flags d LEFT JOIN bp_derived bd ON bd.patient_id=d.patient_id LEFT JOIN Tc_Hdl_Ratio ld ON ld.patient_id=d.patient_id;

-- lastly we can create a column that counts the total number of risk factor as symptom frequency 
ALTER TABLE final_table ADD(risk_count NUMBER);
UPDATE final_table SET risk_count = is_smoking+have_diabetes+on_bp_meds+have_fh_asthma+hypertension+have_chlhdl+have_chltot;




-- as last few steps before matlab let's view all columns that we will be sending to matlab
-- quick profiling of engineered features 
-- display first 20 rows 
SELECT * FROM final_table FETCH FIRST 20 ROWS ONLY;
-- display number of patients per age group and their percentage 

SELECT patient_age_group, COUNT(*) AS num_patients, ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM final_table GROUP BY patient_age_group ORDER BY patient_age_group;
-- display the number of patients who smoke and their percentage

SELECT risk_count,COUNT(*) AS num_patients, ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM final_table GROUP BY risk_count ORDER BY risk_count;

SELECT MIN(pulse_pressure) as min_pulse_pressure,MAX(pulse_pressure) as max_pulse_pressure,ROUND(AVG(pulse_pressure),2) as avg_pulse_pressure FROM final_table; 

SELECT SUM(CASE WHEN pulse_pressure is NULL THEN 1 ELSE 0 END) as pulse_pressure_null_count ,ROUND(SUM(CASE WHEN pulse_pressure IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS pulse_pressure_null_percentage FROM final_table;


SELECT gender, COUNT(*)  AS num_patients,ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM final_table GROUP BY gender;


SELECT have_chlhdl, COUNT(*) AS num_patients,ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM final_table GROUP BY have_chlhdl ORDER BY have_chlhdl;

SELECT have_chltot, COUNT(*) AS num_patients,ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM final_table GROUP BY have_chltot ORDER BY have_chltot;


SELECT is_smoking, COUNT(*) AS num_patients,ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM final_table GROUP BY is_smoking ORDER BY is_smoking;
-- display the number of patients who have diabetes and their percentage
SELECT have_diabetes, COUNT(*) AS num_patients,ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM final_table GROUP BY have_diabetes ORDER BY have_diabetes;
-- display the number of patients who are on bp meds and their percentage
SELECT on_bp_meds, COUNT(*) AS num_patients,ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM final_table GROUP BY on_bp_meds ORDER BY on_bp_meds;
-- display the number of patients who have family history of asthma and their percentage 
SELECT have_fh_asthma, COUNT(*) AS num_patients,ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM final_table GROUP BY have_fh_asthma ORDER BY have_fh_asthma;
-- display the number of patients whose asthma has worsened and their percentage 
SELECT asthma_worsened, COUNT(*) AS num_patients,ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM final_table GROUP BY asthma_worsened ORDER BY asthma_worsened;
-- display the number of patients according to the mway distance interval and their percentage

SELECT mwaydist_interval, COUNT(*) AS num_patients,ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM final_table GROUP BY mwaydist_interval ORDER BY mwaydist_interval;
-- display the number of patients who have hypertension and their percentage
SELECT hypertension, COUNT(*) AS num_patients,ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() *100,2) || '%' AS percentage FROM final_table GROUP BY hypertension ORDER BY hypertension;
SELECT * FROM final_table;
SELECT COUNT(*) FROM final_table;
SELECT column_name,data_type FROM user_tab_columns WHERE table_name='FINAL_TABLE';

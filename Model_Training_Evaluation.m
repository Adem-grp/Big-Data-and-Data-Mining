T=readtable("final_table.csv");
head(T);
summary(T);
% needed 'preserve' because some values came out negative although they
% shouldn't have 
opts.VariableNamingRule = 'preserve';
% hypertension, mwaydist_interval, asthma_worsened, have_fh_asthma,
% on_bp_meds, have_diabetes, is_smoking, gender
% all can be categorical patient_age_group can stay double for now
% depending on the model and it is performance change it to categorical 
% apparently null values are as follows:
% recent_chlhdl=6183, recent_chltot=4719 and tc_hdl_ratio=7997
% therefore, these are excluded from training since only thing they would
% do is to introduce bias
% Convert relevant columns to categorical
T.hypertension = categorical(T.HYPERTENSION);
T.mwaydist_interval = categorical(T.MWAYDIST_INTERVAL);
T.asthma_worsened = categorical(T.ASTHMA_WORSENED);
T.have_fh_asthma = categorical(T.HAVE_FH_ASTHMA);
T.on_bp_meds = categorical(T.ON_BP_MEDS);
T.have_diabetes = categorical(T.HAVE_DIABETES);
T.is_smoking = categorical(T.IS_SMOKING);
T.gender = categorical(T.GENDER);
T.patient_age_group= categorical(T.PATIENT_AGE_GROUP);
T.have_chlhdl=categorical(T.HAVE_CHLHDL);
T.have_chltot=categorical(T.HAVE_CHLTOT);
% EDA 
% relationship between age and asthma
figure;

subplot(2,2,1);
histogram(T.asthma_worsened);
title("Asthma-worsened Distribution");
xlabel("Asthma-worsened");
ylabel("Patient Count");
% less than %20 of the patients have asthma_worsened as true 
subplot(2,2,2);
age_stats = groupsummary(T,"PATIENT_AGE_GROUP","mean","ASTHMA_WORSENED");
plot(age_stats.PATIENT_AGE_GROUP,age_stats.mean_ASTHMA_WORSENED);
title("Age Groups - Asthma-worsened");
xlabel("Age Groups");
ylabel("Asthma-worsened");
% pulse pressure change according to age 
subplot(2,2,3);
boxchart(T.asthma_worsened,T.PULSE_PRESSURE);
title("Pulse Pressure - Asthma Worsened");
ylabel("Pulse Pressure");
xlabel("Asthma Worsened");

subplot(2,2,4);
boxplot(T.RISK_COUNT,T.asthma_worsened);
title("Asthma Worsened -Risk Count");
ylabel("Count");
xlabel("Asthma-worsened");

figure;
subplot(2,2,1);
dist_stats=groupsummary(T,"mwaydist_interval","mean","ASTHMA_WORSENED");
bar(dist_stats.mwaydist_interval,dist_stats.mean_ASTHMA_WORSENED *100);
title('Asthma Worsened Prevalence by Motorway Proximity');
xlabel('Distance from Motorway (km)');
ylabel('Prevalence (%)');

subplot(2,2,2);
smok_stats=groupsummary(T,"is_smoking","mean","ASTHMA_WORSENED");
barh(smok_stats.is_smoking,smok_stats.mean_ASTHMA_WORSENED * 100);
title("Asthma Worsened Prevalence by Smoke Status");
ylabel("Smok Status");
xlabel("Prevalence (%)");
% Analyze the relationship between hypertension and asthma worsening
subplot(2,2,3);
hypertension_stats = groupsummary(T, "hypertension", "mean", "ASTHMA_WORSENED");
bar(hypertension_stats.hypertension, hypertension_stats.mean_ASTHMA_WORSENED * 100);
title("Asthma Worsened Prevalence by Hypertension Status");
xlabel("Hypertension Status");
ylabel("Prevalence (%)");

subplot(2,2,4);
gender_stats = groupsummary(T,"gender","mean","ASTHMA_WORSENED");
plot(gender_stats.gender,gender_stats.mean_ASTHMA_WORSENED);
title("Gender - Asthma-worsened");
xlabel("Gender");
ylabel("Asthma-worsened");

 
figure; 
subplot(1,2,1);

heatmap(T,"have_diabetes","have_fh_asthma","ColorVariable","ASTHMA_WORSENED");
title("(A) Diabetes/Family History of Asthma - Asthma Worsened Relation");

subplot(1,2,2);
heatmap(T,"on_bp_meds","hypertension","ColorVariable","ASTHMA_WORSENED");
title("(B) BP Meds/Hypertension-Asthma Worsened relationship");



% model data prep 
Y=T.asthma_worsened;

X=T(: ,{'gender','patient_age_group','is_smoking','have_diabetes','have_chlhdl','have_chltot','on_bp_meds', ...
    'have_fh_asthma','mwaydist_interval','PULSE_PRESSURE', ...
    'hypertension','RECENT_SBP','RISK_COUNT'});
rng(42);
cv=cvpartition(height(T),'HoldOut',0.3);
% train test split 
idxTrain=training(cv);
idxTest = test(cv);
X_train=X(idxTrain,:);
Y_train=Y(idxTrain);
X_test = X(idxTest,:);
Y_test = Y(idxTest);

% for logistic regression turn asthma_worsened to double 
Y_train_num=double(Y_train)-1;
Y_test_num=double(Y_test)-1;
% training the model 
% because of the poor recall values 
% I decided to add class weights so that models can focus on high-risk
% patients


% for the weights I have tried x3 and x4 and decided that x3.5 would be the
% optimal number for my case.

weight_log = ones(size(Y_train_num));
weight_log(Y_train_num==1) = 3.5;  % asthma worsened cases have x3.5 more

logmodel=fitglm(X_train,Y_train_num,"Distribution","binomial","Weights",weight_log);
problog=predict(logmodel,X_test);
Y_predlog=double(problog >0.4);


% decision tree classifier
% prior and uniform help the model see "0" and "1" as equal despite the
% sample size imbalance.
% limited the splits as it causes errors.
treemodel=fitctree(X_train,Y_train,"Prior","uniform","MaxNumSplits",20);
view(treemodel,"Mode","graph");
Y_predtree=predict(treemodel,X_test);



%Random Forest
% cost matrix is needed to fix the negative aspects of imbalanced data 
cost_matrix = [0 ,1 ; 3.5, 0]
% cost matrix works with false positive and false negative costs 
% therefore, I set the false negatives to cost x3.5 more 
% since having false negative is more risky in health.
random_forest_model=TreeBagger(200,X_train,Y_train,'Method',"classification", ...
    "OOBPrediction","On","OOBPredictorImportance","On","Cost",cost_matrix);
[pred_rf,score_rf] = predict(random_forest_model,X_test); % get the prediction and its score
pred_rf=categorical(pred_rf,categories(Y_train)); % make the pred categorical



vars=X_train.Properties.VariableNames;
rf_imp =random_forest_model.OOBPermutedPredictorDeltaError;
log_imp =abs(logmodel.Coefficients.Estimate(2:end));
tree_imp = predictorImportance(treemodel);

fprintf("Logistic Regression Importance:\n");
for i=1:length(vars)
    fprintf('%-25s : %.4f\n', vars{i}, log_imp(i));
end

fprintf("Random Forest Importance:\n");
for i=1:length(vars)
    fprintf('%-25s : %.4f\n', vars{i}, rf_imp(i));
end

fprintf("Decision Tree Importance:\n");
for i=1:length(vars)
    fprintf('%-25s : %.4f\n', vars{i}, tree_imp(i));
end

% evaluation will be done for the three models here.
% confusion chart, accuracy, precision,recall,ROC,AUC
% confusion charts
figure;
subplot(2,2,1);
confusionchart(categorical(Y_test_num),categorical(Y_predlog));
title("(A) Logistic Regression - Asthma Worsened Classification");

subplot(2,2,2);
confusionchart(Y_test,Y_predtree);
title("(B) Decision Tree - Asthma Worsened Classification");

subplot(2,2,3);
confusionchart(Y_test,pred_rf);
title("(C) Random Forest- Asthma Worsened Classification");


function performance = calculate_metrics(Y_true,Y_pred,model) 
% make sure that categoricals are turned to double since we are calculating
% performance 
    if iscategorical(Y_true);
        Y_true=str2double(string(Y_true));
    end 
    if iscategorical(Y_pred);
        Y_pred=str2double(string(Y_pred));
    end 
    Y_true=double(Y_true);
    Y_pred=double(Y_pred); % in case if statements are skipped 
    % next step is to find the True positive False positive and false
    % negative since we are using mean and Y_pred Y_true for accuracy 
    % there is no need to calculate True negative for now.
    True_p = sum((Y_pred==1) &(Y_true==1));
    False_p = sum((Y_pred==1) &(Y_true==0));
    %True_n = sum((Y_pred==0) & (Y_true==0));
    False_n = sum((Y_pred==0) &(Y_true==1));
    accuracy = mean(Y_true == Y_pred);
    precision= True_p /(True_p+False_p);
    recall= True_p /(True_p+False_n);


    fprintf("Results:\n");
    fprintf('Accuracy: %.2f%%\n', accuracy * 100);
    fprintf("Precision: %.2f%%\n",precision *100);
    fprintf("Recall: %.2f%%\n",recall* 100);
    performance.accuracy=accuracy;
    performance.precision=precision;
    performance.recall=recall;
end


fprintf("Logistic Regression Metrics:\n");
performance_log=calculate_metrics(Y_test_num,Y_predlog,logmodel);
fprintf("Decision Tree Metrics:\n");
performance_tree=calculate_metrics(Y_test,Y_predtree,treemodel);
fprintf("Random Forest Metrics:\n");
performance_rf = calculate_metrics(Y_test, pred_rf, random_forest_model);

% ROC and AUC
[FPR_log,TPR_log,~,AUC_log] =perfcurve(Y_test_num,problog,1);

% another prediction is needed for ROC and AUC for decision tree 
[~,tree_score] = predict(treemodel,X_test);

cats=categories(Y_train);


pos_col = find(strcmp(cats,"1"));


pos_idx = "1";

tree_pos_sc= tree_score(:,pos_col);
[FPR_tree, TPR_tree, ~, AUC_tree] = perfcurve(Y_test, tree_pos_sc, pos_idx);

rf_pos_sc=score_rf(:,pos_col);
[FPR_rf, TPR_rf, ~, AUC_rf] = perfcurve(Y_test, rf_pos_sc, pos_idx);

% Plot ROC curves for each model
subplot(2,2,4);
plot(FPR_log, TPR_log, 'DisplayName', 'Logistic Regression (AUC = ' + string(AUC_log) + ')');
hold on;
plot(FPR_tree, TPR_tree, 'DisplayName', 'Decision Tree (AUC = ' + string(AUC_tree) + ')');
plot(FPR_rf, TPR_rf, 'DisplayName', 'Random Forest (AUC = ' + string(AUC_rf) + ')');
xlabel('False Positive Rate');
ylabel('True Positive Rate');
title('(D) ROC Curves for Asthma Worsened Classification Models');
lgd=legend('show', 'Location', 'southeast');
lgd.FontSize=8;
lgd.Box="off";
hold off;

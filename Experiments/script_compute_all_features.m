%% Alto saxophone boundary detection algorithm
% Jyoti Narang @ GTCMT 2017

%clear all; clc; close all;

addpath('../svm_windows');
addpath('../Features');
fba_relative_path = '../../../../../Desktop/FBA/FBA';
band_option = 'concert'; %'concert', 'symphonic'
instrument_option = 'Alto Saxophone';
segment_option = [];
score_option = [];
year_option = '2013';

audition_metadata = scanFBA(fba_relative_path, ...
    band_option, ...
    instrument_option, ...
    segment_option, ...
    score_option, ...
    year_option);

accuracy_final = 0;
%The initial experiment for feature subset selection was performed using
%the same distribution for training and testing dataset i.e uniform distribution of the training set as well as test set was taken into consideration.
%The commented code below does that experiment.
%Code for k-fold cross validation using SVM classifier 
% for j=1:10:length(audition_metadata.file_paths)
%     train_start = j;
%     train_end = min(train_start+9,length(audition_metadata.file_paths));
%     [final_training_vector,final_training_classification_group] = computeFeaturesFromDataSet(audition_metadata, 4096, 2048, [train_start:train_end], 'train');
%     [final_testing_feature_vector,final_testing_classification_group] = computeFeaturesFromDataSet(audition_metadata, 4096, 2048, [train_start:train_end], 'test');
% 
%     final_training_normalized = zscore(final_training_vector);
%     final_testing_normalized = zscore(final_testing_feature_vector);
%     model = svmtrain(final_training_classification_group, final_training_normalized, '-c 1.8 -g 0.3 -b 1');
%     [predict_label, accuracy, decision] = svmpredict(final_testing_classification_group, final_testing_normalized, model);
%     accuracy_final = accuracy_final+accuracy(1);
% end

%Code for running  training and testing classification 
[final_training_vector,final_training_classification_group] = computeFeaturesFromDataSet(audition_metadata, 4096, 2048, [31:40], 'train');
%[final_testing_feature_vector,final_testing_classification_group] = computeFeaturesFromDataSet(audition_metadata, 4096, 2048, [1:30], 'test');

final_training_normalized = zscore(final_training_vector);
%This computation is being done to put the values between -1 and 1 which
%the SVM classifier generally expects.
final_training_normalized = final_training_normalized/2;
%final_testing_normalized = zscore(final_testing_feature_vector);
%model = svmtrain(final_training_classification_group, final_training_normalized, '-c 1.8 -g 0.3 -b 1');
%[predict_label, accuracy, decision] = svmpredict(final_testing_classification_group, final_testing_normalized, model);
%[final_feature_vector,classification_vector] = computeFeaturesForFile(audition_metadata, iBlockLength, iHopLength)
% model = fitcknn(abs(final_feature_vector),final_classification_group,'NumNeighbors',11);
% cvmodel = crossval(model);
% loss = kfoldLoss(cvmodel);
% disp('Percentage accuracy');
% 
% accuracy = 100-100*loss;
% disp(accuracy);
%wrong_data = myImprovedCrossValidator(final_feature_vector,final_classification_group,10);
% for i =1:length(final_feature_vector)
%     if(isinf(final_feature_vector(i,1)))
%         continue;
%     else
%         result(i,:) = final_feature_vector(i,:);amaz
%         classifier(i,:) = final_classification_group(i,:);
%     end
% end   
% final_feature_zscore = zscore(result);
% model = fitcknn(result,classifier,'NumNeighbors',21);
% %model = fitcknn(final_feature_zscore,final_classification_group,'NumNeighbors',21);
% cvmodel = crossval(model);
% loss = kfoldLoss(cvmodel);
% disp('Percentage accuracy');
% %[m,~] = size(final_feature_vector);
% %disp(((m-wrong_data)/m)*100);
% accuracy = 100-100*loss;
% disp(accuracy);

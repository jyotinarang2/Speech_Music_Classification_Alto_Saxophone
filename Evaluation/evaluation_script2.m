%Compute feature accuracy by training on the entire data points
%This experiment is being performed with just zscore normalization
%clear all;close all;clc;

addpath('../svm_windows');
addpath('../Features');
addpath('../Experiments');
%load ../Saved_Models/model_31_40_removed.mat

disp('SVM training started');
model = svmtrain(final_training_classification_group, final_training_normalized, '-c 100 -g 0.0002 -b 1');
disp('Training finished');
%Compute features for a test file and predict
[file_feature_vector,classification_vector_file] = computeFeaturesForFile(audition_metadata, 4096, 2048, 81);
normalized_file = zscore(file_feature_vector);
[predict_label, accuracy, decision] = svmpredict(classification_vector_file, normalized_file, model);

%Calculate the mean accuracy
[C,order] = confusionmat(classification_vector_file,predict_label);
sum_speech = sum(C(1,:));
sum_music = sum(C(2,:));
speech_vector_accuracy = C(1,1)/sum_speech;
music_vector_accuracy = C(2,2)/sum_music;
file_accuracy = (speech_vector_accuracy+music_vector_accuracy)/2;
disp(file_accuracy);


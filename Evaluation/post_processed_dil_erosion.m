%Script to compute feature accuracy with random sampling of data points.
%Normalization method has been changed from zscore to zscore/2
%Post-processing step of median filtering has been applied to improve the
%accuracy of the classified file.Further processing is done using dilation
%and erosion.

clear all;close all;clc;

addpath('../svm_windows');
addpath('../Features');
addpath('../Experiments');
addpath('../Post-Processing');
load ../Saved_Models/svm_1_20_removed.mat

%Generate any 2000 numbers in the length of the speech and music elements
rand_numbers_speech = randi([1 length(index_speech)],1,10000);
rand_numbers_music = randi([1 length(index_music)],1,10000);

%Get the indexes of random speech and music elements
speech_elements = index_speech(rand_numbers_speech);
music_elements = index_music(rand_numbers_music);

%Get the final features and class sets respectively
features_speech = final_training_vector(speech_elements,:);
speech_class = final_training_classification_group(speech_elements,:);

%Get the final music features and class respectively
features_music = final_training_vector(music_elements,:);
music_class = final_training_classification_group(music_elements);

%Join and shuffle the collected small dataset
final_features = [features_speech;features_music];
final_class = [speech_class;music_class];

%Shuffle
shuffle_index = randperm(length(final_class));
shuffled_features = final_features(shuffle_index,:);
shuffled_class = final_class(shuffle_index);

%Train SVM with this small dataset
normalized = zscore(shuffled_features);
normalized = normalized/2;
disp('Starting training of classifier');
model = svmtrain(shuffled_class, normalized, '-c 10 -g 0.0001 -b 1');

%Compute features for a test file and predict
[file_feature_vector,classification_vector_file] = computeFeaturesForFile(audition_metadata, 4096, 2048, 31);
normalized_file = zscore(file_feature_vector);
normalized_file = normalized_file/2;
[predict_label, accuracy, decision] = svmpredict(classification_vector_file, normalized_file, model);

%Calculate the mean accuracy
[C,order] = confusionmat(classification_vector_file,predict_label);
sum_speech = sum(C(1,:));
sum_music = sum(C(2,:));
speech_vector_accuracy = C(1,1)/sum_speech;
music_vector_accuracy = C(2,2)/sum_music;
file_accuracy = (speech_vector_accuracy+music_vector_accuracy)/2;
disp(file_accuracy);

%Apply median filter on the output file and compute the accuracy again
% y = computeMedianFilter(predict_label,10); %A window size of 10 has been used 
% [C1,order1] = confusionmat(classification_vector_file,y);
% sum_speech = sum(C1(1,:));
% sum_music = sum(C1(2,:));
% speech_vector_accuracy = C1(1,1)/sum_speech;
% music_vector_accuracy = C1(2,2)/sum_music;
% file_accuracy = (speech_vector_accuracy+music_vector_accuracy)/2;
% disp(file_accuracy);

disp('Now applying dilation and erosion operation');
%Declare a strel element

st = strel([1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1]);
y = imclose(predict_label,st);
[C1,order1] = confusionmat(classification_vector_file,y);
sum_speech = sum(C1(1,:));
sum_music = sum(C1(2,:));
speech_vector_accuracy = C1(1,1)/sum_speech;
music_vector_accuracy = C1(2,2)/sum_music;
file_accuracy = (speech_vector_accuracy+music_vector_accuracy)/2;
disp(file_accuracy);


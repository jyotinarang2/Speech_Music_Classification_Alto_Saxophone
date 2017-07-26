clear all;close all;clc;

addpath('../svm_windows');
addpath('../Features');
addpath('../Experiments');
load ../Saved_Models/model_31_40_removed.mat

%Generate any 2000 numbers in the length of the speech and music elements
rand_numbers_speech = randi([1 length(index_speech)],1,2000);
rand_numbers_music = randi([1 length(index_music)],1,2000);

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
model = svmtrain(shuffled_class, normalized, '-c 100 -g 0.0002 -b 1');

%Compute features for a test file and predict
[file_feature_vector,classification_vector_file] = computeFeaturesForFile(audition_metadata, 4096, 2048, 40);
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


%Compute feature accuracy by training on the entire data points
%Training carried out on all files on data from 2013 and testing is
%performed on files from year 2014.

clear all;close all;clc;

addpath('../svm_windows');
addpath('../Features');
addpath('../Experiments');
load ../Saved_Models/svm_all_files_training.mat

fba_relative_path = '../../../../../Desktop/FBA/FBA';
band_option = 'concert'; %'concert', 'symphonic'
instrument_option = 'Alto Saxophone';
segment_option = [];
score_option = [];
year_option = '2015';

audition_metadata = scanFBA(fba_relative_path, ...
    band_option, ...
    instrument_option, ...
    segment_option, ...
    score_option, ...
    year_option);
% final_training_normalized = final_training_normalized/2;
% disp('SVM training started');
% model = svmtrain(final_training_classification_group, final_training_normalized, '-c 100 -g 0.0002 -b 1');
% disp('Training finished');
%Compute features for a test file and predict
total = 0;
for file_number=1:length(audition_metadata.path_segments)
    [file_feature_vector,classification_vector_file] = computeFeaturesForFile(audition_metadata, 4096, 2048, file_number);
    normalized_file = zscore(file_feature_vector);
    %normalized_file = normalized_file/2;
    [predict_label, accuracy, decision] = svmpredict(classification_vector_file, normalized_file, model);

    %Calculate the mean accuracy
    [C,order] = confusionmat(classification_vector_file,predict_label);
    sum_speech = sum(C(1,:));
    sum_music = sum(C(2,:));
    speech_vector_accuracy = C(1,1)/sum_speech;
    music_vector_accuracy = C(2,2)/sum_music;
    file_accuracy = (speech_vector_accuracy+music_vector_accuracy)/2;
    disp(file_accuracy);


    disp('Now applying dilation and erosion operation');
    %Declare a strel element

    st = strel([1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1]);
    y = imclose(predict_label,st);
    [C1,order1] = confusionmat(classification_vector_file,y);
    sum_speech = sum(C1(1,:));
    sum_music = sum(C1(2,:));
    speech_vector_accuracy = C1(1,1)/sum_speech;
    music_vector_accuracy = C1(2,2)/sum_music;
    file_accuracy = (speech_vector_accuracy+music_vector_accuracy)/2;
    disp(file_accuracy);
    total = total+file_accuracy;
end
disp('Final accuracy');

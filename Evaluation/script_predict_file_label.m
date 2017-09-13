clear all;close all;clc;

addpath('../svm_windows');
addpath('../Features');
addpath('../Experiments');
addpath('../Post-Processing');
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

student_ids = scanStudentIds(band_option, instrument_option, year_option);

for i=1:length(audition_metadata.file_paths)
[file_feature_vector] = computeFeaturesForFileWithoutClassification(audition_metadata, 4096, 2048, i);

normalized_file = zscore(file_feature_vector);
%Work on figuring out the prediction without label
classification_vector_file = ones(length(file_feature_vector),1);
[predict_label, accuracy, decision] = svmpredict(classification_vector_file, normalized_file, model);

st = strel([1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1]);
y = imclose(predict_label,st);
music_pieces = convert_values_to_time(y);
file_name = strcat(num2str(student_ids(i)),'.txt');
writetable(struct2table(music_pieces),strcat('../Alto Saxophone Files/',file_name));
end
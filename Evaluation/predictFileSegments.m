%------------------------------------------------------
%@param: sourcePath - Input file path to be annotated
%@param: destinationPath - Location of the annotated file
%------------------------------------------------------
%Note : This function takes a trained model as input which is
%hard-coded here for convenience
%------------------------------------------------------
function predictFileSegments(sourcePath, destinationPath)
    addpath('../svm_windows');
    addpath('../Features');
    addpath('../Experiments');
    addpath('../Post-Processing');
    load ../Saved_Models/svm_all_files_training.mat
    blockLength = 4096;
    hopLength = 2048;
    [file_feature_vector] = computeFeaturesForFile(sourcePath, blockLength, hopLength);
    normalized_file = zscore(file_feature_vector);
    classification_vector_file = ones(length(file_feature_vector),1);
    [predict_label, ~, ~] = svmpredict(classification_vector_file, normalized_file, model);
    st = strel(ones(23,1));
    y = imclose(predict_label,st);
    music_pieces = convert_values_to_time(y);
    %file_name = strcat(num2str(student_ids(i)),'.txt');
    writetable(struct2table(music_pieces),destinationPath);
end
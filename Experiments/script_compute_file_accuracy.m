%This is the script to compute the accuracy of a file provided training has
%been carried out earlier.
%@Param : model - SVM trained model
%@Param : audition_metadata - the files 
total = 0;
correctly_classified_speech = 0;
correctly_classified_music = 0;
total_speech = 0;
total_music = 0;
% for i=1:10
[final_feature_vector_file,classification_vector_file] = computeFeaturesForFile(audition_metadata, 4096, 2048, 35);
final_feature_vector_file = zscore(final_feature_vector_file);
%This line was added to use a different normalization parameter.
%final_feature_vector_file = final_feature_vector_file/2;
[predict_label, accuracy, decision] = svmpredict(classification_vector_file, final_feature_vector_file, model);
[C,order] = confusionmat(classification_vector_file,predict_label);
sum_speech = sum(C(1,:));
sum_music = sum(C(2,:));
speech_vector_accuracy = C(1,1)/sum_speech;
music_vector_accuracy = C(2,2)/sum_music;
file_accuracy = (speech_vector_accuracy+music_vector_accuracy)/2;
total = total+file_accuracy;
correctly_classified_speech = correctly_classified_speech+C(1,1);
correctly_classified_music = correctly_classified_music+C(2,2);
total_speech = total_speech+sum_speech;
total_music = total_music+sum_music;
% end
%total = total/10;
disp(total);
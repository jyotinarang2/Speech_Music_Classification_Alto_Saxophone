%OneR classifier essentially predicts the accuracy with a single feature
%with boundary conditions. Weka comes up with multiple boundary conditions
%for giving the accuracy with oneR . Here, assuming RMS is the best feature
%to compute the feature accuracy, feature accuracy is being compute using a
%single boundary condition with RMS as feature.
for k=31:40
disp('Reading file number');disp(k);
[final_feature_vector_file,classification_vector_file] = computeFeaturesForFile(audition_metadata, 4096, 2048, k);
check = zeros(length(classification_vector_file),1);
for i=1:length(final_feature_vector_file)
if(final_feature_vector_file(i,1))> -33
check(i) = 2;
end
end
index = find(check==0);
check(index)=1;
[C,order] = confusionmat(classification_vector_file,check);
sum_speech = sum(C(1,:));
sum_music = sum(C(2,:));
speech_vector_accuracy = C(1,1)/sum_speech;
music_vector_accuracy = C(2,2)/sum_music;
file_accuracy = (speech_vector_accuracy+music_vector_accuracy)/2;
%disp('File number');
%disp(k);
disp('Accuracy');
disp(file_accuracy);
end
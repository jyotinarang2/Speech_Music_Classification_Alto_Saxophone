%The script is an implementation of sequential forward selection algorithm for the best feature selection .
%This script is written assuming the training vectors and testing vectors
%are available in memory . 
%The script takes features and adds the feature leading to maximum
%accuracy to the feature space until we run out of features . 
%@param : feature_mapping is the number of features to be tested with .One can add more features here as well. 

feature_mapping = {'MFCC(1)','MFCC(2)','MFCC(3)','MFCC(4)','MFCC(5)','MFCC(6)','MFCC(7)','MFCC(8)','MFCC(9)','MFCC(10)','MFCC(11)','MFCC(12)','MFCC(13)',...
    'RMS','Spectral Centroid','Spectral Kurtosis','Spectral Skewness','Spectral Flux','Spectral Flatness','Spectral RollOff','Time Predictivity Ratio',...
    'Spectral Crest','Zero Crossings','Spectral Tonal Power Ratio','Spectral Spread','Spectral Slope','Spectral Decrease'};
final_training_normalized = zscore(final_training_vector);
final_testing_normalized = zscore(final_testing_feature_vector);
%feature_accuracy = zeros(size(final_training_normalized,2),1);
max_accuracy = 0;
objective_function_accuracy = 0;
final_feature_vector = [];
final_test_vector = [];
initial_feature_vector = final_training_normalized;
initial_test_vector = final_testing_normalized;
final_feature_list = {};
i=1;

while(size(initial_feature_vector,2)>0)
    disp('Iteration number');
    disp(i);
    max_accuracy = 0;
    for k=1:size(initial_feature_vector,2)
        disp('Running for feature number ..');
        disp(k);
        train_feature = [final_feature_vector initial_feature_vector(:,k)];
        test_feature = [final_test_vector initial_test_vector(:,k)];
        model = svmtrain(final_training_classification_group, train_feature, '-c 1.8 -g 0.3 -b 1');
        [predict_label, accuracy, decision] = svmpredict(final_testing_classification_group, test_feature, model);
        if(accuracy(1)>max_accuracy)
            max_accuracy = accuracy(1);
            feature_number = k; 
        end
    end
    
 %a.Now we need to add the feature with max accuracy to
 %final_feature_vector .
 %b.Remove the feature from the feature mapping
 %c.Store the values of the feature with max accuracy .
 
%  if(~(max_accuracy > objective_function_accuracy))
%      break;
%  end
 if(max_accuracy > objective_function_accuracy)
   objective_function_accuracy = max_accuracy;
 end
 %objective_function_accuracy = max_accuracy;
 final_feature_vector = [final_feature_vector initial_feature_vector(:,feature_number)];
 final_test_vector = [final_test_vector initial_test_vector(:,feature_number)];
 feature_with_accuracy = strcat(strcat(feature_mapping{feature_number},':'),string(max_accuracy));
 final_feature_list{i} = feature_with_accuracy;
 i = i+1;
 %Remove the feature from initial_feature_vector
 initial_feature_vector(:,feature_number) = [];
 initial_test_vector(:,feature_number) = [];
 
 %Also remove the feature from the feature_mapping
 feature_mapping(feature_number) = [];
    
end

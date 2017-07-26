%% Alto Saxophone segment detection experiment 
% Jyoti Narang @ GTCMT 2017
%This script is no londer in use
%clear all; clc; close all;


fba_relative_path = '../../../Desktop/Desktop/FBA';
band_option = 'concert'; %'concert', 'symphonic'
instrument_option = 'Percussion';
segment_option = [];
score_option = [];
year_option = '2013';

audition_metadata = scanFBA(fba_relative_path, ...
    band_option, ...
    instrument_option, ...
    segment_option, ...
    score_option, ...
    year_option);


[final_feature_vector,final_classification_group] = rmsSpectralCentroidKnnFeatureAccuracy(audition_metadata);
%wrong_data = myImprovedCrossValidator(final_feature_vector,final_classification_group,10);
for i =1:length(final_feature_vector)
    if(isinf(final_feature_vector(i,1)))
        continue;
    else
        result(i,:) = final_feature_vector(i,:);
        classifier(i,:) = final_classification_group(i,:);
    end
end   
final_feature_zscore = zscore(result);
%model = fitcknn(result,classifier,'NumNeighbors',11);
model = fitcknn(final_feature_zscore,final_classification_group,'NumNeighbors',11);
cvmodel = crossval(model);
loss = kfoldLoss(cvmodel);
disp('Percentage accuracy');
% [m,~] = size(final_feature_vector);
% disp(((m-wrong_data)/m)*100);
accuracy = 100-100*loss;
disp(accuracy);
%Normalize the output vectors 
%audio_vector = audio_vector/sum(audio_vector);
%music_vector = music_vector/sum(music_vector);
%Plot bar graph for the instrument 
%edges = [0:100:5000];
%bar(edges,audio_vector,'g');hold on;
%bar(edges,music_vector,'r');
%legend('audio','music');
%xlabel('Rms Value(DB)');
%ylabel('Probability');
%cd ../experiments/snare_etude_regression/
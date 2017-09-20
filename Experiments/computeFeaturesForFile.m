%This function is used to compute the features for a single file.The
%features are same as that got by Feature Selection algorithm.Any single
%file acts as a test file for testing the feature accuracy.
function [final_feature_vector] = computeFeaturesForFile(fileName, iBlockLength, iHopLength)
try
   [y,Fs]=audioread(char(fileName));
catch exception
   disp('corrupt file');
   final_feature_vector = [];
   return;
end

disp('Reading a sample audio file..');
% Downmix the signal if it is 2 channeled
[~,n] = size(y);
if(n==2)
    stereo_to_mono = (y(:,1)+y(:,2))/2;
else
    stereo_to_mono = y;
end
% Normalize the audio signal 
stereo_to_mono = stereo_to_mono/max(abs(stereo_to_mono));  
[rms_feature_vector, segment_start] = computeRmsFeature(stereo_to_mono, iBlockLength, iHopLength, Fs);
afWindow = hann(iBlockLength,'periodic');
[X,f,t]     = spectrogram(  [stereo_to_mono; zeros(iBlockLength,1)],...
                                    afWindow,...
                                    iBlockLength-iHopLength,...
                                    iBlockLength,...
                                    Fs);
    
X = abs(X)*2/iBlockLength;                            
spectral_mfcc = [];
spectral_mfcc = computeSpectralMfcc(X, Fs);
spectral_rolloff_feature_vector = computeSpectralRollOff(X, Fs, 0.85);
spectral_rolloff_feature_vector = spectral_rolloff_feature_vector';
[zero_crossings,t] = computeTimeZeroCrossing(stereo_to_mono, iBlockLength, iHopLength, Fs);
zero_crossings = zero_crossings';
spectral_spread = computeFeatureSpectralSpread(X, Fs);
spectral_spread = spectral_spread';
spectral_slope = computeFeatureSpectralSlope(X, Fs);
spectral_slope = spectral_slope';
 
final_feature_vector = [];
for i = 1:length(rms_feature_vector)
    final_feature_vector(:,i) = [rms_feature_vector(i);spectral_slope(i);zero_crossings(i);spectral_mfcc(2,i);spectral_rolloff_feature_vector(i);
    spectral_mfcc(4,i);spectral_mfcc(13,i);spectral_mfcc(11,i);spectral_mfcc(1,i);spectral_mfcc(12,i);spectral_spread(i);];
end
final_feature_vector = final_feature_vector';
end
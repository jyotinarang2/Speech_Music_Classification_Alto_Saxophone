%This function is used to compute the features for a single file.The
%features are same as that got by Feature Selection algorithm.Any single
%file acts as a test file for testing the feature accuracy.
function [final_feature_vector] = computeFeaturesForFileWithoutClassification(audition_metadata, iBlockLength, iHopLength,file_number)
%file_number = 51;
file_name = audition_metadata.file_paths(file_number);
try
   [y,Fs]=audioread(char(file_name));
catch exception
   disp('corrupt file');
   final_feature_vector = [];
   %classification_vector = [];
   return;
end
%     iBlockLength = 4096;
%     iHopLength = 2048;
disp('Reading a sample audio file..');
disp(file_number);
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
    %spectral_centroid = computeSpectralCentroid(X, Fs);
    %spectral_centroid = spectral_centroid';
    %skewness_feature_vector = computeSpectralSkewness(X, Fs);
    %skewness_feature_vector = skewness_feature_vector';
    %kurtosis_feature_vector = computeSpectralKurtosis(X, Fs);
    %kurtosis_feature_vector = kurtosis_feature_vector';
spectral_rolloff_feature_vector = computeSpectralRollOff(X, Fs, 0.85);
spectral_rolloff_feature_vector = spectral_rolloff_feature_vector';
    %spectral_flux = computeSpectralflux(X, Fs);
    %spectral_flux = spectral_flux';
    %spectral_flatness = computeSpectralFlatness(X, Fs);
    %spectral_flatness = spectral_flatness';
[zero_crossings,t] = computeTimeZeroCrossing(stereo_to_mono, iBlockLength, iHopLength, Fs);
zero_crossings = zero_crossings';
    %pitch_chroma = FeatureSpectralPitchChroma(X, Fs);
    %[time_predictivity_ratio,t1] = computeFeatureTimePredictivityRatio(stereo_to_mono, iBlockLength, iHopLength, Fs);
    %time_predictivity_ratio = time_predictivity_ratio';
    %spectral_crest = computeFeatureSpectralCrestFactor(X, Fs);
    %spectral_crest = spectral_crest';
    %spectral_tonal_power_ratio = computeFeatureSpectralTonalPowerRatio(X, Fs);
    %spectral_tonal_power_ratio = spectral_tonal_power_ratio';
spectral_spread = computeFeatureSpectralSpread(X, Fs);
spectral_spread = spectral_spread';
spectral_slope = computeFeatureSpectralSlope(X, Fs);
spectral_slope = spectral_slope';
    %spectral_decrease = computeFeatureSpectralDecrease(X, Fs);
    %spectral_decrease = spectral_decrease';
%     [time_peak_envelope, t] = computeFeatureTimePeakEnvelope(stereo_to_mono, iBlockLength, iHopLength, Fs);
% if cellfun('isempty',audition_metadata.path_segments(file_number))
%    final_feature_vector = [];
%    classification_vector = []; 
%    disp('Empty segment');
%    return;
% end
%file_music_segments = char(audition_metadata.path_segments(file_number));
%classification_vector = [];
%classification_vector = rangeMusicValues(file_music_segments,rms_feature_vector, segment_start, iHopLength, Fs);
 
final_feature_vector = [];
for i = 1:length(rms_feature_vector)
    final_feature_vector(:,i) = [rms_feature_vector(i);spectral_slope(i);zero_crossings(i);spectral_mfcc(2,i);spectral_rolloff_feature_vector(i);
    spectral_mfcc(4,i);spectral_mfcc(13,i);spectral_mfcc(11,i);spectral_mfcc(1,i);spectral_mfcc(12,i);spectral_spread(i);];
end
final_feature_vector = final_feature_vector';
%classification_vector(classification_vector==1) = 2;
%classification_vector(classification_vector==0) = 1;


end
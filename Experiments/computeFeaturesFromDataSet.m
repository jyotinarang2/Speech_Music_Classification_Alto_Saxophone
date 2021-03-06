%This function is used to compute the features found using Feature
%Selection algorithm.
function [final_feature_vector,final_classification_group] = computeFeaturesFromDataSet(audition_metadata, iBlockLength, iHopLength, kFoldFileNumbers, datatype)
final_feature_vector = [];
final_classification_group = [];
outer_loop = [];
if(strcmp(datatype,'train'))
    for j=1:length(audition_metadata.file_paths)
        if(~ismember(j,kFoldFileNumbers))
            outer_loop = [outer_loop j];
        end
    end
end
if(strcmp(datatype,'test'))
   outer_loop = kFoldFileNumbers;
end
    

for j = outer_loop
    file_name = audition_metadata.file_paths(j);
    try
      [y,Fs]=audioread(char(file_name));
    catch exception
        disp('corrupt file')
        continue;
    end
%     iBlockLength = 4096;
%     iHopLength = 2048;
    disp('Reading a sample audio file..');
    disp(j);
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
       
    %spectral_spread = computeSpectralSpread(signal_spectrum, samples_per_frame, Fs);
    %spectral_decrease = computeSpectralDecrease(signal_spectrum, samples_per_frame, Fs);
    %spectral_slope = computeSpectralSlope(signal_spectrum, samples_per_frame, Fs);
    %spectral_crest = computeSpectralCrest(signal_spectrum, samples_per_frame, Fs);
    %spectral_flatness = computeSpectralFlatness(signal_spectrum, samples_per_frame, Fs);
    %spectral_tonal_power_ratio = computeTonalPowerRatio(abs(signal_spectrum), samples_per_frame, Fs);
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
    if cellfun('isempty',audition_metadata.path_segments(j))
        disp('going back')
        continue;
        
    end
    file_music_segments = char(audition_metadata.path_segments(j));
    classification_vector = [];
    classification_vector = rangeMusicValues(file_music_segments,rms_feature_vector, segment_start, iHopLength, Fs);
    
    audio  = 1;
    music = 1;
    audio_vector_mfcc = [];
    music_vector_mfcc = [];
    for i = 1:length(classification_vector)
        if(classification_vector(i)==0)
            audio_vector_mfcc(:,audio) = [rms_feature_vector(i);spectral_slope(i);zero_crossings(i);spectral_mfcc(2,i);spectral_rolloff_feature_vector(i);
                spectral_mfcc(4,i);spectral_mfcc(13,i);spectral_mfcc(11,i);spectral_mfcc(1,i);spectral_mfcc(12,i);spectral_spread(i);];
            %audio_vector_mfcc(:,audio) = [rms_feature_vector(i)];
            audio = audio+1;
        elseif(classification_vector(i)==1)
            %audio_vector_mfcc(:,music) = [rms_feature_vector(i)];
            music_vector_mfcc(:,music) = [rms_feature_vector(i);spectral_slope(i);zero_crossings(i);spectral_mfcc(2,i);spectral_rolloff_feature_vector(i);
                spectral_mfcc(4,i);spectral_mfcc(13,i);spectral_mfcc(11,i);spectral_mfcc(1,i);spectral_mfcc(12,i);spectral_spread(i);];
            music = music+1;
        end
    end
    audio_vector_mfcc = audio_vector_mfcc';
    music_vector_mfcc = music_vector_mfcc';
    resultant_feature_vector = [];
%    classification_group = classification_vector;
    classification_group = [];
    for k =1:length(audio_vector_mfcc)
      resultant_feature_vector(k,:) = audio_vector_mfcc(k,:);
      classification_group(k) = 1;
    end
    m=1;
    no_music_samples = floor(length(music_vector_mfcc)/6);
    rand_numbers = randi([1 length(music_vector_mfcc)],1,no_music_samples);
    music_vector_samples = music_vector_mfcc(rand_numbers,:);
    resultant_feature_vector  = [resultant_feature_vector;music_vector_samples];
    music = [2];
    music_vector_class = repmat(music, (no_music_samples), 1);
    classification_group = classification_group';
    classification_group = [classification_group;music_vector_class];
    %Take every 8th sample from the music vector
%      for s = 1 : length(music_vector_mfcc)
%        resultant_feature_vector(k+m,:) = music_vector_mfcc(s,:);
%        classification_group(k+m) = 2;
%        m= m+1;
%      end

    shuffled_index = randperm(length(resultant_feature_vector));
    shuffled_data = resultant_feature_vector(shuffled_index,:);
    shuffled_class = classification_group(shuffled_index,:);
    %rand_numbers = randi([1 length(resultant_feature_vector)],1,300);
    file_features = shuffled_data;%(rand_numbers,:);
    file_class = shuffled_class;%(rand_numbers,:);
    final_feature_vector = [final_feature_vector;file_features];
    final_classification_group = [final_classification_group;file_class];    
       

end
end
%-------------------------------------------------------%
%@param fileName :File containing the segments of music and speech
%@param feature_vector :vector containing the feature value and the
%segment start number
%@param sampling_rate : Input sampling rate
%@retval classification vector specifying the segments containing music elements.The
%music elements are marked with a 1 value
%--------------------------------------------------------%
function classification_vector = rangeMusicValues(fileName, feature_vector, segment_vector, iHopSize, sampling_rate)
%segment_samples = 4096;
[start, duration] = textread(fileName,'%f %f','headerlines',1);
classification_vector = zeros(length(feature_vector),1);
location_music_start =1;

% After reading the file ,segregate the input audio file into audio and music segments 
for k=1:length(start)
    start_music_sample = start(k)*sampling_rate;
    end_music_sample = start_music_sample + duration(k)*sampling_rate;
    
%     while(1)
%         if((rms_feature_vector(location_music_start,2)<start_music_sample)&&(start_music_sample<rms_feature_vector(location_music_start+1,2)))
%           break;
%         end
%         location_music_start = location_music_start+1;
%     end
    while((segment_vector(location_music_start)<start_music_sample))
        location_music_start = location_music_start+1;
    end
    while (start_music_sample < end_music_sample)        
        start_music_sample =start_music_sample + iHopSize;
        classification_vector(location_music_start) = 1;
        location_music_start = location_music_start+1;
    end
    classification_vector = classification_vector(1:length(feature_vector));
end
end
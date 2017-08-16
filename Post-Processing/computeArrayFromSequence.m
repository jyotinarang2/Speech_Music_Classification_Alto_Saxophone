%This function is used to compute the array converting '1''s to speech and
%'2''s to music.This is just for enhancing the code readability.
function segmentToArray = computeArrayFromSequence(x)
segmentToArray = struct();
k = 1;
count =1;
for i=1:length(x)-1
    if(x(i+1) == x(i))
        count = count+1;
    else
        segmentToArray(k).numberFrames = count;
        if(x(i) == 1)
            segmentToArray(k).type = 'speech';
        else
            segmentToArray(k).type = 'music';
        end
        count = 1;
        k = k+1;
    end
end
end
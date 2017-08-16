%This function will try to merge the elements based on the input elements .
%Input is a structure element containing number of speech and music frames
%and also indicating the class of the frames .The output is  a merged
%sequence of struct element
function mergeArray = mergeArrayFromSequence(input)
mergeArray = struct();
k=1;
% for i=2:length(input)-1
%     if((input(i-1).numberFrames > input(i).numberFrames) && (input(i).numberFrames < input(i+1).numberFrames))
%         mergeArray(k).numberFrames = input(i-1).numberFrames + input(i).numberFrames + input(i+1).numberFrames;
%         mergeArray(k).type = input(i-1).type;
%         k = k+1;
%     else
%         mergeArray(k).numberFrames = input(i).numberFrames;
%         mergeArray(k).type = input(i).type;
%         k = k+1;
%     end
% end
mergeArray(k).numFrames = input(k).numberFrames;
mergeArray(k).type = input(k).type;
for i=2:length(input)-1
    if(input(i).numFrames <= 50)
        mergeArray(k-1).numFrames = input(i-1).numFrames+input(i).numberFrames+input(i+1).numFrames;
        %mergeArray(k).type = 
        k = k+1;
    else
        k = k+1;
        mergeArray(k).numFrames = input(k).numFrames;
        mergeArray(k).type = input(k).type;
    end
        
end
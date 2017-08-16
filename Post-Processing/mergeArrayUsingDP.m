%This function is used to get the output segments given   
function merged = mergeArrayUsingDP(input, no_segments)
merged = input;
while(length(merged)> no_segments)
    count_field = extractfield(merged,'numberFrames');
    index = find(count_field == min(count_field));
    if((index(1)~=1)&&(index(1)~=length(merged)))
        merged(index(1)-1).numberFrames = merged(index(1)-1).numberFrames + merged(index(1)).numberFrames + merged(index(1)+1).numberFrames;
        merged(index(1)) = [];
        merged(index(1)) = [];
    elseif index(1)==1
        merged(index(1)+1).numberFrames = merged(index(1)+1).numberFrames + merged(index(1)).numberFrames;
        merged(index(1)) = [];
    elseif(index(1) ==length(merged))
        merged(index(1)-1).numberFrames = merged(index(1)-1).numberFrames + merged(index(1)).numberFrames;
        merged(index(1)) = [];
    end
end
    
addpath('../Experiments');
input = computeArrayFromSequence(y);
output = mergeArrayUsingDP(input,10);
time_sec = [];
for i=1:length(output)
time_sec(i) = (output(i).numberFrames*2048)/44100;
end
time_sec = time_sec';
music_segments = struct();
initial = time_sec(1);
k=1;
for i=2:length(time_sec)
    if(mod(i,2)==0)
        music_segments(k).start = initial;
        music_segments(k).duration = time_sec(i);
        initial = initial+time_sec(i);
        k = k+1;
    else
        initial = initial+time_sec(i);
    end
end
        


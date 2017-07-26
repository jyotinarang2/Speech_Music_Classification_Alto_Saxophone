%Script to plot the spectrogram for a file with the names given below
file_name =   '../../../../Desktop/FBA/FBA\2013-2014\concertbandscores\28667\28667.mp3';
file_music_segments = '..\..\..\..\Desktop\FBA\FBA2013\FBA2013\concertbandscores\28667\28667_segment.txt';
[y,Fs]=audioread(file_name);
stereo_to_mono = (y(:,1)+y(:,2))/2;
stereo_to_mono = stereo_to_mono/max(stereo_to_mono);
iBlockLength = 4096;
iHopLength = 2048;
afWindow = hann(iBlockLength,'periodic');
mag_spectrum = fft(stereo_to_mono);
plot(abs(mag_spectrum));
% [X,f,t]     = spectrogram(  [stereo_to_mono; zeros(iBlockLength,1)],...
%                                     afWindow,...
%                                     iBlockLength-iHopLength,...
%                                     iBlockLength,...
%                                     Fs);
% To plot the spectrogram of the values which spectrogram returns */
%imagesc(20*log10(abs(X)))
%For reversing the axes 
%axis xy

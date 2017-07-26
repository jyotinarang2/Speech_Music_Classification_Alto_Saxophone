function feature_spectral_flatness = computeSpectralFlatness(X,  fs)
% iNumOfBlocks    = ceil (length(X)/iBlockLength);
% feature_spectral_flatness = zeros(iNumOfBlocks,3);
% for k=1:iNumOfBlocks
%     
%     start_sample = (k-1)*iBlockLength+1;
%     end_sample = min(start_sample+iBlockLength-1,length(X));
%     XLog = log(X(start_sample:end_sample)+1e-20);
%     spectral_flatness = exp(mean(XLog,1))/mean(X(start_sample:end_sample));
%     
%     feature_spectral_flatness(k,1) = spectral_flatness;
%     feature_spectral_flatness(k,2) = start_sample;
% end
XLog    = log(X+1e-20);
feature_spectral_flatness     = exp(mean(XLog,1)) ./ (mean(X,1));
   
% avoid NaN for silence frames
feature_spectral_flatness (sum(X,1) == 0) = 0;
end
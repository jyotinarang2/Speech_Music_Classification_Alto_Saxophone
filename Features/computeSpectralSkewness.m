%--------------------------------------------------------
%@brief computes spectral skewness 
%@param X: fft of the input vector
%--------------------------------------------------------
function skewness_feature_vector = computeSpectralSkewness(X, Fs)
% iNumOfBlocks    = ceil (length(X)/iBlockLength);
% skewness_feature_vector = zeros(iNumOfBlocks,3);
% for k=1:iNumOfBlocks
%     start_sample = (k-1)*iBlockLength+1;
%     end_sample = min(start_sample+iBlockLength-1,length(X));
% mu_x = mean(abs(X(start_sample:end_sample)));
%     std_x = std(abs(X(start_sample:end_sample)));
%     X(start_sample:end_sample) = X(start_sample:end_sample) - repmat(mu_x,end_sample-start_sample+1,1);
%     skewness = sum(X(start_sample:end_sample).^3)/std_x^3*iBlockLength;
%     skewness_feature_vector(k,1) = skewness;
%     skewness_feature_vector(k,2) = start_sample;
% end
mu_x    = mean(abs(X), 1);
std_x   = std(abs(X), 1);

 % compute skewness
X       = X - repmat(mu_x, size(X,1), 1);
skewness_feature_vector    = sum ((X.^3)./(repmat(std_x, size(X,1), 1).^3*size(X,1)));

% avoid NaN for silence frames
skewness_feature_vector (sum(X,1) == 0) = 0;

end
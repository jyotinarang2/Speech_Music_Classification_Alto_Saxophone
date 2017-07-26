%-------------------------------------------------------------%
%@brief:computes spectral kurtosis 
%@param X : fft of the input signal

%-------------------------------------------------------------
function kurtosis_feature_vector = computeSpectralKurtosis(X, Fs)
% iNumOfBlocks    = ceil (length(X)/iBlockLength);
%kurtosis_feature_vector = zeros(iNumOfBlocks,3);
% for k=1:iNumOfBlocks
%     start_sample = (k-1)*iBlockLength+1;
%     end_sample = min(start_sample+iBlockLength-1,length(X));
%     mu_x = mean(abs(X(start_sample:end_sample)));
%     std_x = std(abs(X(start_sample:end_sample)));
%     X(start_sample:end_sample) = X(start_sample:end_sample) - repmat(mu_x,end_sample-start_sample+1,1);
%     kurtosis = sum(X(start_sample:end_sample).^4)/std_x^4*iBlockLength;
%     kurtosis_feature_vector(k,1) = kurtosis;
%     kurtosis_feature_vector(k,2) = start_sample;
% end
% compute mean and standard deviation
mu_x    = mean(abs(X), 1);
std_x   = std(abs(X), 1);

% remove mean
X       = X - repmat(mu_x, size(X,1), 1);

% compute kurtosis
kurtosis_feature_vector     = sum ((X.^4)./(repmat(std_x, size(X,1), 1).^4*size(X,1)));

kurtosis_feature_vector     = kurtosis_feature_vector-3;
       
% avoid NaN for silence frames
kurtosis_feature_vector (sum(X,1) == 0) = 0;
end
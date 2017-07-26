%-----------------------------------------------------------------------
%@brief computes spectal flux of the signal
%@param X : frequency spectrum of the signal 

%--------------------------------------------------------------------
function feature_spectral_flux = computeSpectralflux(X, fs)
% iNumOfBlocks    = ceil (length(X)/iBlockLength);
% feature_spectral_flux = zeros(iNumOfBlocks,3);
% for k=1:iNumOfBlocks
%     start_sample = (k-1)*iBlockLength+1;
%     end_sample = min(start_sample+iBlockLength-1,length(X));
%     %Set first diff to 0
%     deltaX = diff([X(start_sample);X(start_sample:end_sample)]);
%     %Compute flux for this block now
%     flux = sqrt(sum(deltaX.^2))/(end_sample-start_sample+1);
%     feature_spectral_flux(k,1) = flux;
%     feature_spectral_flux(k,2) = start_sample;
% end
% difference spectrum (set first diff to zero)
afDeltaX    = diff([X(:,1), X],1,2);
    
% flux
feature_spectral_flux       = sqrt(sum(afDeltaX.^2))/size(X,1);
end
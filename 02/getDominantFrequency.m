function dominant_frequency = getDominantFrequency(signal, sampleRate)
    windowSize = 1024;
    hopSize = 512;
    
    % Estimate the power spectral density (PSD) using pwelch
    [psd, frequencies] = pwelch(signal, [], [], windowSize, sampleRate);
    
    % Find the bin with maximum PSD as the dominant frequency bin
    [~, maxBinIndex] = max(psd);
    
    % Convert bin index to frequency
    dominant_frequency = frequencies(maxBinIndex);
end
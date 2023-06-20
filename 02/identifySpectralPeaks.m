function identifySpectralPeaks(signal, sampleRate, threshold)
    % Compute the power spectral density (PSD) using the periodogram
    [psd, frequencies] = periodogram(signal, [], [], sampleRate);
    
    % Find peaks in the PSD above the specified threshold
    [peakValues, peakIndices] = findpeaks(psd, 'MinPeakHeight', threshold);
    
    % Display the identified peaks
    disp('Spectral Peaks:');
    for i = 1:numel(peakValues)
        peakFrequency = frequencies(peakIndices(i));
        peakAmplitude = peakValues(i);
        disp(['Frequency: ', num2str(peakFrequency), ' Hz, Amplitude: ', num2str(peakAmplitude)]);
    end
end
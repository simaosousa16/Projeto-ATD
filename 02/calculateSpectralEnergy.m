function spectralEnergy = calculateSpectralEnergy(signal)
    % Apply Fourier transform to the signal
    spectrum = fft(signal);
    
    % Calculate the magnitude spectrum
    magnitudeSpectrum = abs(spectrum);
    
    % Square the magnitude spectrum to get the energy spectrum
    energySpectrum = magnitudeSpectrum .^ 2;
    
    % Calculate the spectral energy by summing up the energy spectrum
    spectralEnergy = sum(energySpectrum);
end
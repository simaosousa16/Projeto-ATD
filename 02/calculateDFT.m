function dft = calculateDFT(digit, participant, recording)
    % Load the audio signal
    [y, fs] = loadRec(digit, participant, recording);
    
    % Calculate the DFT
    dft = fft(y);
    
    % Plot the magnitude spectrum
    L = length(y);
    f = fs*(0:(L/2))/L;  % Frequency axis
    dft_mag = abs(dft/L);
    dft_mag = dft_mag(1:L/2+1);
    
    plot(f, dft_mag);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    title('DFT Spectrum');
end

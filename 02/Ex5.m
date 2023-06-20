function Ex5()
    % Step 1: Data Preparation
    participant = '02';
    digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]; % List of digits in your dataset
    recordingsPerDigit = 50;
    resolution = 100; % Lower resolution for less smooth lines
    
    spectra = cell(1, numel(digits)); % Cell array to store the amplitude spectra for each digit
    first_quartile = cell(1, numel(digits)); % Cell array to store the first quartile for each digit
    third_quartile = cell(1, numel(digits)); % Cell array to store the third quartile for each digit
    
    for digitIndex = 1:numel(digits)
        digit = digits(digitIndex);
        signals = cell(1, recordingsPerDigit); % Cell array to store signals for the current digit
        
        % Load the signals for the current digit
        for recording = 1:recordingsPerDigit-1
            [soundData, sampleRate] = loadRec(digit, participant, recording);            
            soundData = zeroPadding(soundData, max(sampleRate));
            signals{recording} = soundData;
        end
        
        % Calculate the amplitude spectra for each signal
        amplitude_spectra = zeros(recordingsPerDigit, resolution/2+1);
        for i = 1:recordingsPerDigit-1
            signal = signals{i};
            N = numel(signal);
            % 4 Diferent Windows to use Rectangular, Hann or Hanning,
            % BlackMan anda Flat Top
            rectangularWindow = ones(size(signal)); % Create a Rectangular window of length N
            hannWindow = hann(N); % Create a Hann window
            blackmanWindow = blackman(N); % Create a Blackman window
            flatTopWindow = flattopwin(N); % Create a Flat Top window
            windowedSignal = signal .* rectangularWindow; % Apply the window function to the signal
            spectrum = abs(fft(windowedSignal, resolution)); % Compute the Fourier spectrum
            amplitude_spectrum = spectrum(1:resolution/2+1); % Keep only frequencies up to the Nyquist frequency
            amplitude_spectra(i, :) = amplitude_spectrum;
        end
        
        % Calculate the median and quartiles for the amplitude spectra
        median_spectrum = median(amplitude_spectra, 1);
        first_quartile_spectrum = quantile(amplitude_spectra, 0.25);
        third_quartile_spectrum = quantile(amplitude_spectra, 0.75);
        
        % Normalize the spectra by the number of samples
        median_spectrum = median_spectrum / N;
        first_quartile_spectrum = first_quartile_spectrum / N;
        third_quartile_spectrum = third_quartile_spectrum / N;
        
        % Store the spectra and quartiles for the current digit
        spectra{digitIndex} = median_spectrum;
        first_quartile{digitIndex} = first_quartile_spectrum;
        third_quartile{digitIndex} = third_quartile_spectrum;
    end
    
    % Plotting the results
    frequencies = linspace(0, sampleRate/2, resolution/2+1);
    
    figure;
    
    for i = 1:numel(digits)
        % Plot the amplitude spectra
        subplot(2, 5, i);
        hold on;
        plot(frequencies, 20*log10(spectra{i}), 'b', 'LineWidth', 1);
        plot(frequencies, 20*log10(first_quartile{i}), '--r', 'LineWidth', 1);
        plot(frequencies, 20*log10(third_quartile{i}), '--k', 'LineWidth', 1);
        xlabel('Frequency (Hz)');
        ylabel('Amplitude (dB)');
        title(['Digit ', num2str(digits(i)), ' (Amplitude Spectrum)']);
        legend('Median', 'First Quartile', 'Third Quartile');
    end
    
    
    % Calculate the dominant frequency, spectral energy and spectral peaks for each signal
    for i = 1:numel(digits)
        signal = spectra{i};
        sampleRate = max(sampleRate);

        dominant_frequency = getDominantFrequency(signal, sampleRate);
        spectral_energy = calculateSpectralEnergy(signal);

        % Print the dominant frequency and spectral energy for the digit
        disp(['Digit ', num2str(digits(i))]);
        disp(['Dominant Frequency: ', num2str(dominant_frequency), ' Hz']);
        disp(['Spectral Energy: ', num2str(spectral_energy)]);

        % Identify spectral peaks
        minPeakHeight = -140;
        identifySpectralPeaks(signal, sampleRate, minPeakHeight);
    end

end

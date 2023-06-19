function Ex5()
    % Step 1: Data Preparation
    participant = '02';
    digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]; % List of digits in your dataset
    recordingsPerDigit = 50;
    
    spectra = cell(1, numel(digits)); % Cell array to store the amplitude spectra for each digit
    first_quartile = cell(1, numel(digits)); % Cell array to store the first quartile for each digit
    third_quartile = cell(1, numel(digits)); % Cell array to store the third quartile for each digit
    
    for digitIndex = 1:numel(digits)
        digit = digits(digitIndex);
        signals = cell(1, recordingsPerDigit); % Cell array to store signals for the current digit
        
        % Load the signals for the current digit
        for recording = 1:recordingsPerDigit
            [soundData, sampleRate] = loadRec(digit, participant, num2str(recording-1));
            soundData = zeroPadding(soundData, max(sampleRate));
            signals{recording} = soundData;
        end
        
        % Calculate the amplitude spectra for each signal
        amplitude_spectra = zeros(recordingsPerDigit, numel(soundData)/2+1);
        for i = 1:recordingsPerDigit
            signal = signals{i};
            N = numel(signal);
            spectrum = abs(fft(signal)); % Compute the Fourier spectrum
            amplitude_spectrum = spectrum(1:N/2+1); % Keep only frequencies up to the Nyquist frequency
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
    frequencies = linspace(0, sampleRate/2, numel(soundData)/2+1);
    
    figure;
    for i = 1:numel(digits)
        subplot(2, 5, i);
        plot(frequencies, spectra{i}, 'LineWidth', 1);
        hold on;
        plot(frequencies, first_quartile{i}, '--', 'LineWidth', 1);
        plot(frequencies, third_quartile{i}, '--', 'LineWidth', 1);
        xlabel('Frequency (Hz)');
        ylabel('Amplitude');
        title(['Digit ', num2str(digits(i))]);
        legend('Median', 'First Quartile', 'Third Quartile');
    end
end


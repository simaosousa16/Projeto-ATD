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
    
    
    % Calculate spectral median amplitudes for pairs
    matrix_amp = zeros(numel(digits), numel(recordingsPerDigit));
    c = 0;

    for i = 1:digits
        disp(i)
        disp(c)
        digits = num2str(i-1);

        for j = 1:recordingPerDigit-1
            mean_spectrum = mean(amplitude_spectrum); % mediam spectrum amplitude
            matrix_amp(i, j) = mean_spectrum;
        end
        c = c + 1;
        if c == 2
            c = 0;
            str = sprintf('Pares %d e %d', i-2, i-1);
            subplot(2, 3, round(i/2)) % criar um subplot para exibir o boxplot
            boxplot(matrix_amp'); % plotar o boxplot das amplitudes
            ylabel('Amplitude espectral média');
            xlabel('Dígitos');
            xticklabels({'0','1','2','3','4','5','6','7','8','9'});
            title(str);
            matrix_amp = zeros(numel(digits), numel(recordingsPerDigits)); % redefinir a matriz de amplitudes para a próxima iteração
        end
    end
    
    % Calculate spectral median amplitudes for each digit
    median_spec_amp = zeros(1, 10);

    for i = 1:digits
        digit = num2str(i);
        complete_spectra = []; % matrix to keep spectra of all recording per Digit

        for j = 1:recordingsPerDigit-1
            complete_spectra = [all_spectra; amplitude_spectrum];
        end

        median_spectrum = median(all_spectra, 1); % espectro de amplitude mediano
        Q1_spectrum = quantile(all_spectra, 0.25, 1); % primeiro quartil
        Q3_spectrum = quantile(all_spectra, 0.75, 1); % terceiro quartil

        mean_spectrum = mean(median_spectrum); % amplitude espectral média

        median_spec_amp(i+1) = mean_spectrum;

        % Plot graphs
        figure;
        plot(Q1_spectrum);
        hold on;
        plot(Q3_spectrum);
        plot(median_spectrum);
        xlabel('Frequência');
        ylabel('Amplitude');
        title(['Quartile Plot for Digit ', digito]);
        legend('Q1', 'Q3', 'Median');
        

        % Verificar se median_spectrum tem pelo menos 2 elementos antes de definir os limites do eixo x
        if numel(median_spectrum) >= 2
            xlim([1, numel(median_spectrum)]);
        end
    end
    
    %Calculate median spectral energy for each digit
    digits_energy = zeros(1, 10);

    for i = 1:digits
        digit = num2str(i);

        all_energies = []; % matrix to store all recordings energy

        for j = 1:recordingsPerDigit-1
            signal_energy = sum(signals{i}.^2); % cálculo da energia do sinal

            all_energies = [all_energies; signal_energy];
        end

        mean_energy = mean(all_energies); % energia espectral média

        digits_energy(i+1) = mean_energy;

        %Plot the energys
        figure;
        histogram(all_energies);
        xlabel('Energia');
        ylabel('Frequência');
        title(['Histogram of Energy for Digit ', digit]);
    end
    
    
end

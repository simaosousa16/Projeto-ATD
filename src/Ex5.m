function Ex5()
    %%
    % Step 1: Data Preparation
    participant = '02';
    digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]; % List of digits in your dataset
    recordingsPerDigit = 1:50;
    
    %%
    
    %Quartil plot with different windows
    normalized_spectrum = zeros(10, numel(recordingsPerDigit), 24000);

    amplitudes = amplitudes_medias();

    for i = 1:numel(digits)
        digit = digits(i);

        subplot(5, 2, i);
        hold on;

        % Loop sobre as repetições
        for j = 1:numel(recordingsPerDigit)
            recording = recordingsPerDigit(j) -1;
            
            [soundData, sampleRate] = loadRec(digit, participant, recording);
            
            
            % 4 Different Windows to use Rectangular, Hann or Hanning,
            % BlackMan and Flat Top
            window_N = numel(soundData);
            rectangularWindow = ones(size(soundData)); % Create a Rectangular window of length of SoundData
            hannWindow = hann(window_N); % Create a Hann window
            blackmanWindow = blackman(window_N); % Create a Blackman window
            flatTopWindow = flattopwin(window_N); % Create a Flat Top window
            windowedSignal = soundData .* rectangularWindow;
            
            N = sampleRate;

            % Cálculo do espectro do sinal de áudio
            spectrum = fftshift(fft(windowedSignal, N));
            amplitude_spectrum = abs(spectrum);
            start_index = ceil((numel(amplitude_spectrum) + 1) / 2);
            end_index = numel(amplitude_spectrum);
            positive_spectrum = amplitude_spectrum(start_index:end_index);
            normalized_spectrum(i, j, :) = positive_spectrum;
        end

        Q1 = zeros(1, 24000);
        Q2 = zeros(1, 24000);
        Q3 = zeros(1, 24000);

        % Cálculo dos quartis para cada frequência
        for freq = 1:size(normalized_spectrum, 3)
            data = normalized_spectrum(i, :, freq);
            Q1(freq) = quantile(data, 0.25);
            Q2(freq) = quantile(data, 0.50);
            Q3(freq) = quantile(data, 0.75);
        end

        % Plotagem do gráfico de quartis
        
        plot(Q1, '--r')
        plot(Q3, '--black')
        plot(Q2, 'b')

        xlabel('Frequency')
        ylabel('Amplitude')
        title(['Quartile Plot for Digit ', num2str(digit)])
        legend('Q1', 'Q3', 'Median')
        xlim([1,4000])
    end

    sgtitle('Quartile Plots for Digits');

    % Calculate SNR for each digit
    for i = 1:numel(digits)
        digit = digits(i);
        disp(['SNR for Digit ', num2str(digit), ': ', num2str(amplitudes(digit + 1) / std(Q2))]);
    end
    
    %%
    %Calculate median spectral amplitudes for pairs of digits
    matrix_amps = zeros(numel(digits), numel(recordingsPerDigit)); % matriz para armazenar as amplitudes espectrais médias de cada repetição

    c = 0;

    for i = 1:numel(digits)
        disp(i)
        disp(c)
        digit = digits(i);

        for j = 1:numel(recordingsPerDigit)
            recording = recordingsPerDigit(j) -1;
            [soundData, sampleRate] = loadRec(digit, participant, recording);

            % Cálculo do espectro do sinal de áudio
            spectrum = fft(soundData);
            amplitude_spectrum = abs(spectrum);
            positive_spectrum = amplitude_spectrum(1:ceil(end/2)); % manter apenas as frequências positivas

            mean_spectrum = mean(positive_spectrum); % amplitude espectral média

            matrix_amps(i, j) = mean_spectrum; % armazenar a amplitude média na matriz
        end
        
        c = c + 1;

        if c == 2
            c = 0;

            str = sprintf('Pares %d e %d', i-2, i-1);
            subplot(2, 3, round(i/2)) % criar um subplot para exibir o boxplot

            boxplot(matrix_amps'); % plotar o boxplot das amplitudes

            ylabel('Average Spectral Amplitude');
            xlabel('Digits');
            xticklabels({'0','1','2','3','4','5','6','7','8','9'});
            title(str);

            matrix_amps = zeros(numel(digits), numel(recordingsPerDigit)); % redefinir a matriz de amplitudes para a próxima iteração
        end
    end
    
    %%
    %Calculate spectral amplitude for each digit
    figure;
    matrix_spectral_amps = zeros(1, 10); 

    for i = 1:numel(digits)
        digit = digits(i);

        all_spectra = []; 

        for j = 1:numel(recordingsPerDigit)
            recording = recordingsPerDigit(j) -1;
            [soundData, sampleRate] = loadRec(digit, participant, recording);

            
            spectrum = abs(fft(soundData));
            positive_spectrum = spectrum(1:ceil(end/2)); 

            all_spectra = [all_spectra; positive_spectrum];
        end

        median_spectrum = median(all_spectra, 1); 
        Q1_spectrum = quantile(all_spectra, 0.25, 1); 
        Q3_spectrum = quantile(all_spectra, 0.75, 1);

        mean_spectrum = mean(median_spectrum);

        matrix_spectral_amps(i) = mean_spectrum;
    end
    
    plot(digits, matrix_spectral_amps, '-o');
    xlabel('Digit');
    ylabel('Average Spectral Amplitude');
    title('Average Spectral Amplitude For Each Digit');
    
    %%
    %Calculate spectral energy for each digit
    figure;
    spectral_energys = zeros(1, 10);

    for i = 1:numel(digits)
        digit = digits(i);

        all_spectral_energies = [];

        for j = 1:numel(recordingsPerDigit)
            recording = recordingsPerDigit(i) -1;
            [soundData, sampleRate] = loadRec(digit, participant, recording);

            signal_energy = sum(soundData.^2); % cálculo da energia do sinal

            all_spectral_energies = [all_spectral_energies; signal_energy];
        end

        mean_energy = mean(all_spectral_energies); % energia espectral média

        spectral_energys(i) = mean_energy;
    end
    
    plot(spectral_energys, matrix_spectral_amps,"o");
    text(spectral_energys+.02, matrix_spectral_amps, {'0','1','2','3','4','5','6','7','8','9'})
    xlabel('Average Spectral Energy');
    ylabel('Average Spectral Amplitude');
    title('Average Spectral Amplitude by Average Spectral Energy for Each Digit');
end

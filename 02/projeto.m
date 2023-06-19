
clear all
close all

% Especificar o nome dos arquivos .wav em um vetor de caracteres
filenames = ["0_02_0.wav", "1_02_0.wav", "2_02_0.wav", "3_02_0.wav", "4_02_0.wav","5_02_0.wav", "6_02_0.wav", "7_02_0.wav", "8_02_0.wav", "9_02.wav"];


spects0=[];
spects1=[];
spects2=[];
spects3=[];
spects4=[];
spects5=[];
spects6=[];
spects7=[];
spects8=[];
spects9=[];

energia = [];
amplitude_min = [];
amplitude_max = [];

array_q2 = [];
array_q1 = [];
array_q3 = [];
sinais = [];
tempos = [];
% Loop através dos arquivos e ler os sinais usando a função audioread

for i = 1:length(filenames)
    [signal, Fs] = audioread(filenames(i)); %o Fs contem a frequencia de amostragem

    %numero de elementos no array
    N = numel(signal);

    t = [0:N-1].*(1/Fs);

    % Create a subplot
    subplot(4, 3, i);
    %Plot the amplitude spectrum
    plot(t, signal);
    hold on;
    xlabel('Tempo (s)');
    ylabel('Amplitude');
    title(num2str(i-1));
    grid on;
    hold off;


    % ------- 4 -------
    %calculo da energia do sinal continuo e amplitudes maximas
    E = trapz(t, signal.^2)
    Amp_max = max(signal);
    Amp_min = min(signal);
    energia = [energia, E];
    amplitude_max = [amplitude_max, Amp_max];
    amplitude_min = [amplitude_min, Amp_min];

    %inserir a informaçao de cada sinal no respetivo sinal
    if i == 0
        spects0 = [spects0 , E, Amp_max,Amp_min];
    elseif i == 1
        spects1 = [spects1 , E, Amp_max,Amp_min];
    elseif i == 2
        spects2 = [spects2 , E, Amp_max,Amp_min];
    elseif i == 3
        spects3 = [spects3 , E, Amp_max,Amp_min];
    elseif i == 4
        spects4 = [spects4 , E, Amp_max,Amp_min];
    elseif i == 5
        spects5 = [spects5 , E, Amp_max,Amp_min];
    elseif i == 6
        spects6 = [spects6 , E, Amp_max,Amp_min];
    elseif i == 7
        spects7 = [spects7 , E, Amp_max,Amp_min];
    elseif i == 8
        spects8 = [spects8 , E, Amp_max,Amp_min];
    elseif i == 9
        spects9 = [spects9 , E, Amp_max,Amp_min];
    end    

    %--------------- 4.3 --------------------

    if Amp_max > 0.02 && E > 5.5e-06 && Amp_min >= -0.02
        digito = 1;
    elseif Amp_max < 0.01 && Amp_min < -0.01
        digito = 2;
    elseif Amp_max < 0.01 && Amp_min > -0.01 && E > 2e-06
        digito = 3;
    elseif Amp_max > 0.04 && Amp_min < -0.03 && E > 2e-05
        digito = 4;
    elseif Amp_max > 0.02 && Amp_min < -0.015 && E < 6e-06
        digito = 5;
    elseif Amp_max < 0.01 && Amp_min > -0.01 && E < 9e-06
        digito = 6;
    elseif Amp_max > 0.02 && Amp_min < -0.02 && E > 1e-05
        digito = 7;
    elseif Amp_max > 0.02 && Amp_min < -0.01 && E < 4e-06
        digito = 8;
    elseif Amp_max < 0.015 && Amp_min < -0.015 && E > 4e-06
        digito = 9;
    elseif Amp_max > 0.015 && Amp_min < -0.015 && E > 4e-06
        digito = 0;
    end

    disp(digito)

    %---------------------- 5 ------------------------

    % --------------------- retangular --------------
    n = 50;
    mf = 8000;
    spectrum = zeros(50, mf);
    
    for j = 1:n
        % Calcular a transformada de Fourier usando FFT
        fft_signal = fft(signal);
        
        % Calcular o espectro de amplitude unilateral
        amplitude_spectrum = abs(fft_signal / length(signal));
        amplitude_spectrum = amplitude_spectrum(1: floor(length(amplitude_spectrum)/2)+1);
        amplitude_spectrum = amplitude_spectrum(1: mf);
        spectrum(j, 1:length(amplitude_spectrum)) = amplitude_spectrum';
    end
    
    q2 = median((spectrum));
    q1 = quantile((spectrum), 0.25);
    q3 = quantile((spectrum), 0.75);
    
    % Create a subplot
    subplot(4, 3, i);
    % Plotar o espectro de amplitude normalizado
    plot(q2, 'b');
    hold on;
    plot(q1, 'r--');
    plot(q3, 'k--');
    xlabel('Frequência (Hz)');
    ylabel('Amplitude');
    title(num2str(i-1));
    grid on;
    hold off;
    
    %----------- hamming ----------------
    %{
    n = 50;
    mf = 8000;
    spectrum = zeros(50, mf);
    
    % Criar a janela de Hamming
    window_func = hamming(length(signal));
    
    for j = 1:n
        % Aplicar a janela de Hamming ao sinal
        windowed_signal = signal .* window_func;
        
        % Calcular a transformada de Fourier usando FFT
        fft_signal = fft(windowed_signal);
        
        % Calcular o espectro de amplitude unilateral
        amplitude_spectrum = abs(fft_signal / length(windowed_signal));
        amplitude_spectrum = amplitude_spectrum(1: floor(length(amplitude_spectrum)/2)+1);
        amplitude_spectrum = amplitude_spectrum(1: mf);
        spectrum(j, 1:length(amplitude_spectrum)) = amplitude_spectrum';
    end
    
    q2 = median((spectrum));
    q1 = quantile((spectrum), 0.25);
    q3 = quantile((spectrum), 0.75);
    
    % Create a subplot
    subplot(4, 3, i);
    % Plotar o espectro de amplitude normalizado
    plot(q2, 'b');
    hold on;
    plot(q1, 'r--');
    plot(q3, 'k--');
    xlabel('Frequência (Hz)');
    ylabel('Amplitude');
    title(num2str(i-1));
    grid on;
    hold off;
    %}
    %-------------- hanning -------------
    %{
    n = 50;
    mf = 8000;
    spectrum = zeros(50, mf);
    
    % Criar a janela de Hanning
    window_func = hann(length(signal));
    
    for j = 1:n
        % Aplicar a janela de Hanning ao sinal
        windowed_signal = signal .* window_func;
        
        % Calcular a transformada de Fourier usando FFT
        fft_signal = fft(windowed_signal);
        
        % Calcular o espectro de amplitude unilateral
        amplitude_spectrum = abs(fft_signal / length(windowed_signal));
        amplitude_spectrum = amplitude_spectrum(1: floor(length(amplitude_spectrum)/2)+1);
        amplitude_spectrum = amplitude_spectrum(1: mf);
        spectrum(j, 1:length(amplitude_spectrum)) = amplitude_spectrum';
    end
    
    q2 = median((spectrum));
    q1 = quantile((spectrum), 0.25);
    q3 = quantile((spectrum), 0.75);
    
    % Create a subplot
    subplot(4, 3, i);
    % Plotar o espectro de amplitude normalizado
    plot(q2, 'b');
    hold on;
    plot(q1, 'r--');
    plot(q3, 'k--');
    xlabel('Frequência (Hz)');
    ylabel('Amplitude');
    title(num2str(i-1));
    grid on;
    hold off;
    %}
    %-------------- blackman ---------------
    %{
    n = 50;
    mf = 8000;
    spectrum = zeros(50, mf);
    
    % Criar a janela de Blackman
    window_func = blackman(length(signal));
    
    for j = 1:n
        % Aplicar a janela de Blackman ao sinal
        windowed_signal = signal .* window_func;
        
        % Calcular a transformada de Fourier usando FFT
        fft_signal = fft(windowed_signal);
        
        % Calcular o espectro de amplitude unilateral
        amplitude_spectrum = abs(fft_signal / length(windowed_signal));
        amplitude_spectrum = amplitude_spectrum(1: floor(length(amplitude_spectrum)/2)+1);
        amplitude_spectrum = amplitude_spectrum(1: mf);
        spectrum(j, 1:length(amplitude_spectrum)) = amplitude_spectrum';
    end
    
    q2 = median((spectrum));
    q1 = quantile((spectrum), 0.25);
    q3 = quantile((spectrum), 0.75);
    
    % Create a subplot
    subplot(4, 3, i);
    % Plotar o espectro de amplitude normalizado
    plot(q2, 'b');
    hold on;
    plot(q1, 'r--');
    plot(q3, 'k--');
    xlabel('Frequência (Hz)');
    ylabel('Amplitude');
    title(num2str(i-1));
    grid on;
    hold off;

    %}
    % ------------------ 6 -------------------------
    janela = 1000; % Tamanho da janela da STFT (em amostras)
    sobreposicao = janela / 2; % Quantidade de sobreposição entre as janelas (em amostras)
    
    % Calcular a STFT com janela de Hanning
    [s, f, t] = spectrogram(signal, janela, sobreposicao, [], Fs);
    
    % Plotar a STFT
    subplot(4, 3, i);
    imagesc(t, f, 10*log10(abs(s))); % Converter para escala logarítmica para melhor visualização
    axis('xy');
    colorbar;
    xlabel('Tempo (ms)');
    ylabel('Frequência (kHz)');
    title(sprintf('%d', i - 1));
end

%% 
Ex5();


    



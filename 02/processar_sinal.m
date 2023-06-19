function smoothedSignal = processar_sinal(soundData)
        % Normalização do sinal de áudio
        normalizedSignal = soundData / max(abs(soundData));
        
        % Step 2: Apply Low-pass Filter
        cutoffFrequency = 5000; % Defina a frequência de corte desejada (em Hz)
        normalizedCutoff = cutoffFrequency / (48000/2);
        filterOrder = 50; % Defina a ordem do filtro FIR
        
        % Design do filtro FIR passa-baixas
        lowpassFilter = fir1(filterOrder, normalizedCutoff, 'low');
        
        % Aplicação do filtro passa-baixas
        filteredSignal = filter(lowpassFilter, 1, normalizedSignal);
        
        % Step 3: Rectification
        rectifiedSignal = abs(filteredSignal);
        
        % Step 4: Smoothing
        smoothingWindow = 0.1; % Defina o tamanho da janela de suavização (em segundos)
        windowLength = round(smoothingWindow * 48000);
        smoothedSignal = movmean(rectifiedSignal, windowLength); % Suavização com média móvel

end
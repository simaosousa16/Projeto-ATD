function plotEnergy(soundDataArray, sampleRateArray, windowSize)
    numDigits = numel(soundDataArray);
    
    figure;
    
    for i = 1:numDigits
        soundData = soundDataArray{i};
        sampleRate = sampleRateArray(i);
        
        % Calcular o número de janelas
        numSamples = length(soundData);
        numWindows = floor(numSamples / windowSize);
        
        % Inicializar vetor para armazenar a energia de cada janela
        energy = zeros(numWindows, 1);
        
        % Calcular a energia para cada janela
        for j = 1:numWindows
            startIndex = (j - 1) * windowSize + 1;
            endIndex = j * windowSize;
            windowData = soundData(startIndex:endIndex);
            energy(j) = sum(windowData.^2);
        end
        
        % Plotar o gráfico da energia
        subplot(numDigits/2, 2 , i);
        plot(energy);
        xlabel('Janela');
        ylabel('Energia');
        title(['Dígito ', num2str(i-1)]);
    end
end
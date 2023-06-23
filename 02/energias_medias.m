function energias = energias_medias()
    participant = '02';
    energias = zeros(1, 10); % vetor com a amplitude maxima de cada dígito
    recordingsPerDigit = 50;  % Assuming there are 10 recordings per digit    
    
    for digit = 0:9
        E = 0;        
        % Load and store the signals for the current digit
        for recording = 0:recordingsPerDigit-1
            [soundData, sampleRate] = loadRec(digit, participant, recording);
            soundData = zeroPadding(soundData,max(sampleRate));
            envelope = calculateEnvelope(soundData);
            
            E = E + sum(envelope.^2); % calcular a energia discreta do sinal
        end

        E = E /50 ;

        disp(E)
        energias(digit+1) = E;  
    end
end

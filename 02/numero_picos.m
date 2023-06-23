function picos = numero_picos()
    participant = '02';
    picos = zeros(1, 10); % vetor com a amplitude maxima de cada dígito
    recordingsPerDigit = 50;  % Assuming there are 10 recordings per digit    
    
    for digit = 0:9
        n = 0;        
        % Load and store the signals for the current digit
        for recording = 0:recordingsPerDigit-1
            [soundData, sampleRate] = loadRec(digit, participant, recording);
            soundData = zeroPadding(soundData,max(sampleRate));
            envelope = calculateEnvelope(soundData);
            [quantidade,~] = findpeaks(envelope);
            n = n + length(quantidade);
            
        end

        n = n /50 ;

        picos(digit+1) = n;
    end
end

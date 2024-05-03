function amplitudes = amplitudes_medias()

    participant = '02';
    amplitudes = zeros(1, 10); % vetor com a amplitude maxima de cada dígito
    recordingsPerDigit = 50;  % Assuming there are 10 recordings per digit    
    
    for digit = 0:9
        A = 0;        
        % Load and store the signals for the current digit
        for recording = 0:recordingsPerDigit-1
            [soundData, sampleRate] = loadRec(digit, participant, recording);
            soundData = zeroPadding(soundData,max(sampleRate));
            A = A + mean(abs(soundData));
        end

        A = A /50 ;

        amplitudes(digit+1) = A;
    end
end

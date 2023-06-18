function result = getInfoForIF_ELSE(participant)
    recordingsPerDigit = 10;  % Assuming there are 10 recordings per digit
    result = struct('Digit', 0:9, 'PertinentValue1', zeros(1, 10), 'PertinentValue2', zeros(1, 10), 'PertinentValue3', zeros(1, 10));
    
    for digit = 0:9
        digitSignals = cell(1, recordingsPerDigit); % Cell array to store signals for the current digit
        maxLength = 0; % Variable to track the maximum signal length

        % Load and store the signals for the current digit
        for recording = 0:recordingsPerDigit-1
            [soundData, ~] = loadRec(digit, participant, recording);
            digitSignals{recording+1} = soundData;
            maxLength = max(maxLength, length(soundData));
        end
        
        pertinentValue1 = -Inf;  % Variable to track the pertinent value 1 for the current digit
        pertinentValue3 = -Inf;  % Variable to track the pertinent value 3 for the current digit
        
        % Iterate over the digit signals
        for recording = 1:recordingsPerDigit
            soundData = digitSignals{recording};
            
            % Calculate pertinent values (example calculations)
            envelope = abs(soundData);
            maxAmp = max(envelope);
            power = calculatePower(soundData);
            meanPower = mean(power);
            
            % Update the pertinent values if the current values are larger
            if maxAmp > pertinentValue1
                pertinentValue1 = maxAmp;
            end
            
            if meanPower > pertinentValue3
                pertinentValue3 = meanPower;
            end
        end
        
        % Store the results in the data structure
        result(digit+1).PertinentValue1 = pertinentValue1;
        result(digit+1).PertinentValue3 = pertinentValue3;
    end
end


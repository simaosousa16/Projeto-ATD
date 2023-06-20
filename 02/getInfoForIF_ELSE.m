function result = getInfoForIF_ELSE(participant)
    recordingsPerDigit = 50;  % Assuming there are 10 recordings per digit
    result = struct('Digit', 0:9, 'PertinentValue1', zeros(1, 10), 'PertinentValue2', zeros(1, 10), 'PertinentValue3', zeros(1, 10));
    
    for digit = 0:9
        digitSignals = cell(1, recordingsPerDigit); % Cell array to store signals for the current digit
        maxLength = 0; % Variable to track the maximum signal length

        % Load and store the signals for the current digit
        for recording = 0:recordingsPerDigit-1
            [soundData, sampleRate] = loadRec(digit, participant, recording);

            soundData = zeroPadding(soundData,max(sampleRate));

            digitSignals{recording+1} = soundData;
            maxLength = max(maxLength, length(soundData));
        end
        
        max_max_rate = -Inf;  % Variable to track the pertinent value 3 for the current digit
        max_energy = -Inf;
        min_max_rate = -Inf;
        min_energy = -Inf;

        % Iterate over the digit signals
        for recording = 1:recordingsPerDigit

            soundData = digitSignals{recording};
            smoothedSignal = processar_sinal(soundData);
            smoothedSignal = calculateEnvelope(smoothedSignal);
           88
            % Calculate Duration
            duration = length(smoothedSignal) / 48000;
            
            % Find Peaks and Valleys
            [peaks, peakLocations] = findpeaks(smoothedSignal);
            
            % Calculate Rate of Change
            differences = diff(smoothedSignal);
            timeDifferences = 1 / 48000; % Tempo entre amostras
            maxRateOfChange = max(differences ./ timeDifferences);
            
            % Calculate Energy
            energy = sum(smoothedSignal.^2);
            
            fprintf('Duration: %.2f seconds\n', duration);
            fprintf('Number of Peaks: %d\n', length(peaks));
            fprintf('Maximum Rate of Change: %.2f\n', maxRateOfChange);
            fprintf('Energy: %.2f\n', energy);


            % Update the pertinent values if the current values are larger
            
            if maxRateOfChange < min_max_rate
                min_max_rate = maxRateOfChange;
            end

            if maxRateOfChange > max_max_rate
                 max_max_rate= maxRateOfChange;
            end
            
            if energy > max_energy
                max_energy = energy ;
            end

            if energy < min_energy
                min_energy = energy;
            end

        end
        
        % Store the results in the data structure
        result(digit+1).max_max_rate = max_max_rate;
        result(digit+1).min_max_rate = min_max_rate;
        result(digit+1).max_energy = max_energy;
        result(digit+1).min_energy = min_energy;
    end
end


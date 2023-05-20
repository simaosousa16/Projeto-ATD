function calculateMeanSignals(participant, recordingsPerDigit, targetSize)
    meanSignals = cell(1, 10); % Cell array to store mean signals for each digit

    for digit = 0:9
        digitSignals = cell(0, recordingsPerDigit); % Cell array to store signals for the current digit
        maxLength = 0; % Variable to track the maximum signal length
        
        % Load and store the signals for the current digit
        for recording = 0:recordingsPerDigit-1
            disp(recording)
            [soundData, ~] = loadRec(digit, participant, recording);
            digitSignals{recording+1} = soundData;
            maxLength = max(maxLength, length(soundData));
        end
        
        % Process the signals for the current digit
        processedSignals = zeros(maxLength, recordingsPerDigit);
        for i = 1:recordingsPerDigit
            signal = digitSignals{i};
            % Zero-padding or truncation to the maximum length
            if length(signal) < maxLength
                signal = [signal; zeros(maxLength - length(signal), 1)];
            else
                signal = signal(1:maxLength);
            end
            processedSignals(:, i) = signal;
        end
        
        % Calculate the mean signal for the current digit
        meanSignal = mean(processedSignals, 2);
        
        % Zero padding to the target size
        paddedSignal = zeroPadding(meanSignal, targetSize);
        
        % Store the mean signal for the current digit
        meanSignals{digit+1} = paddedSignal;
        
        % Save the mean signal to a file
        filename = sprintf('mean_signal_digit_%02d.mat', digit);
        saveData(filename, paddedSignal);
    end
end

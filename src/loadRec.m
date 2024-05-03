function [yn, fs] = loadRec(digit, participant, recording)

    disp(digit)
    disp(participant)
    disp(recording)

    filename = sprintf('%d_%s_%d.wav', digit, participant, recording);
    
    try
        [audio, fs] = audioread(filename);
        
        % Calculate the energy of the audio signal
        energy = sum(audio.^2, 2);
        
        % Set a threshold to determine the silence
        threshold = 0.06 * max(energy);
        
        % Find the index where the energy exceeds the threshold
        startIndex = find(energy > threshold, 1);
        
        % Write the audio data starting from the startIndex to the output file
        yn = audio(startIndex:end);

    catch
        disp('Arquivo não encontrado.');
        yn = [];  % Retornar um vetor vazio em caso de falha na leitura do arquivo
    end
end

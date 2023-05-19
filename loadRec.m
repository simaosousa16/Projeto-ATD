function loadRec[participant, digit, recording]
    filename = sprintf('%d_%d_%d.wav',digit, participant, recording);
    
    try
        [yn,fs] = audioread('noisy_voice.wav');

        disp(fs);
        
        disp('Arquivo carregado:');
        disp(data);
    catch
        disp('Arquivo não encontrado.');
    end
end
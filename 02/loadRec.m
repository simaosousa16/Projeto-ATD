function [yn,fs] = loadRec(digit, participant, recording)

    disp(digit)
    disp(participant)
    disp(recording)

    filename = sprintf('%d_%s_%d.wav', digit, participant, recording);
    display(filename)
    try
        [yn, fs] = audioread(filename);

        disp('Arquivo carregado:');
    catch
        disp('Arquivo não encontrado.');
        yn = [];  % Retornar um vetor vazio em caso de falha na leitura do arquivo
    end
end

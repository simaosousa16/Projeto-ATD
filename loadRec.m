    function loadRec(participant, digit, recording)
    filename = sprintf('participant_%d_digit_%d_recording_%d.txt', participant, digit, recording);
    
    try
        fileID = fopen(filename, 'r');
        data = fscanf(fileID, '%s');
        fclose(fileID);
        
        disp('Arquivo carregado:');
        disp(data);
    catch
        disp('Arquivo não encontrado.');
    end
end
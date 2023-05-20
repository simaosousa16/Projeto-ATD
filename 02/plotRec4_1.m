function plotRec4_1(soundDataArray, sampleRateArray,digito1,digito2)
    try
        figure;

        t = (0:length(soundDataArray{digito1+1})-1) / sampleRateArray(digito1+1); % Time vector
        
        % Par de dígitos: 0 e 1
        plot(t, soundDataArray{digito1+1}, 'b');
        hold on;
        
        t = (0:length(soundDataArray{digito2+1})-1) / sampleRateArray(digito2+1); % Time vector
        plot(t, soundDataArray{digito2+1}, 'r');
        
        xlabel('Tempo (s)');
        ylabel('Amplitude');

           
        titulo = sprintf('Par de Dígitos: %d e %d',digito1,digito2);

        disp(titulo)
        title(titulo);

        legend(int2str(digito1), int2str(digito2));
        
    catch
        disp('Error.');
    end
end

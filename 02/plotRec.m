function plotRec(soundData, sampleRate)
    try
        t = (0:length(soundData(1))-1) / sampleRate(1)(1); % Time vector

        figure;

        subplot(10, 1, 2);
        plot(t, soundData);
        xlabel('Time (s)');
        ylabel('Amplitude');
        title('0');

        
    catch
        disp('Error.');
    end
end

function plotRec4(soundDataArray, sampleRateArray)
    try
        figure;
        for i = 1 : 10
            t = (0:length(soundDataArray{i})-1) / sampleRateArray(i); % Time vector
            subplot(4, 3, i);
            plot(t, soundDataArray{i});
            xlabel('Time (s)');
            ylabel('Amplitude');
            title(i-1);
        end
    catch
        disp('Error.');
    end
end

function plotRec4_1(soundDataArray, sampleRateArray, digito1, digito2)
    try
        figure;

        t1 = (0:length(soundDataArray{digito1+1})-1) / sampleRateArray(digito1+1); % Time vector for digit 1
        t2 = (0:length(soundDataArray{digito2+1})-1) / sampleRateArray(digito2+1); % Time vector for digit 2

        % Plot digit 1
        plot(t1, soundDataArray{digito1+1}, 'b');
        hold on;

        % Plot digit 2
        plot(t2, soundDataArray{digito2+1}, 'r');

        % Find maximum amplitude for each digit recording
        [maxAmplitude1, maxIndex1] = max(abs(soundDataArray{digito1+1}));
        [maxAmplitude2, maxIndex2] = max(abs(soundDataArray{digito2+1}));

        % Display maximum amplitude using circles on the plot
        plot(t1(maxIndex1), soundDataArray{digito1+1}(maxIndex1), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
        plot(t2(maxIndex2), soundDataArray{digito2+1}(maxIndex2), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

        xlabel('Time (s)');
        ylabel('Amplitude');

        title(sprintf('Digit Pair: %d and %d', digito1, digito2));

        legend(sprintf('Max amplitude %d', digito1), sprintf('Max amplitude %d', digito2));
        
        grid on;

    catch
        disp('Error.');
    end
end


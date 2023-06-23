function Ex6()
    % Step 1: Data Preparation
    participant = '02';
    digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]; % List of digits in your dataset
    recordingsPerDigit = 1:50;
    
    %Plot Digit Spectogram
    figure;
    for i = 1:numel(digits)
        digit = digits(i);
        [soundData, sampleRate] = loadRec(digit, participant, 0);
        
        Ts = 1/sampleRate;
        N = length(soundData);

        T = N*Ts;
        N_frame = 1024;
        N_overlap = 512;

        subplot(5, 2, i);
        spectrogram(soundData, N_frame, N_overlap, [], sampleRate, 'yaxis');

        title(['Digit Spectogram ', num2str(digit)]);
    end
    
    % Fundamental Frequencies Windows
    figure;
    for i = 1:numel(digits)
        digit = digits(i);
        windows_soundData = []; % Initialize an empty array for windows sound data
        
        [soundData, sampleRate] = loadRec(digit, participant, 0);
        windows_soundData = [windows_soundData; soundData]; % Concatenate sound data from all recordings

        subplot(5, 2, i);
        T_frame = N_frame*Ts;
        T_overlap = N_overlap*Ts;

        N = numel(windows_soundData);
        numFrames = floor((N)/(N_frame - N_overlap));
        while N < (numFrames-1)*(N_frame - N_overlap) + N_frame
            windows_soundData = [windows_soundData; 0.];
            N = numel(windows_soundData);
        end

        rectangularWindow = ones(size(windows_soundData)); % Create a Rectangular window of length N
        hannWindow = hann(N_frame); % Create a Hann window
        blackmanWindow = blackman(N_frame); % Create a Blackman window
        flatTopWindow = flattopwin(N_frame); % Create a Flat Top window

        if mod(N_frame, 2)==0
            f_frame = -sampleRate/2:sampleRate/N_frame:sampleRate/2-sampleRate/N_frame;
        else
            f_frame = -sampleRate/2+sampleRate/(2*N_frame):sampleRate/N_frame - sampleRate/2-sampleRate/(2*N_frame);
        end

        f_frame = f_frame(floor(N_frame/2)+1:end);

        stft = [];

        for j = 0:numFrames-1
            frameStart = j*(N_frame - N_overlap) + 1;
            frameEnd = frameStart + N_frame-1;
            frame = windows_soundData(frameStart:frameEnd);
            frame = frame.*hannWindow; %Change window here for one of the 4
            DFT_frame = fftshift(fft(frame));
            DFT_frame = DFT_frame(floor(N_frame/2)+1:end);
            mags_frame = abs(DFT_frame)/N_frame;
            stft = [stft; mags_frame'];
        end

        fundamental_freqs = [];

        for j = 1:numFrames
            index = find(stft(j, :) == max(stft(j, :)));
            fundamental_freqs = [fundamental_freqs; f_frame(index)];
        end

        t = 0:T_frame-T_overlap:(numFrames-1)*(T_frame-T_overlap);

        plot(t, fundamental_freqs, '-ob');
        xlabel('t(s)');
        ylabel('Fundamental Freq (Hz)');
        ylim('auto');
        xlim('auto');
        title(['Fundamental Frequency Windows - Digit ', num2str(digit)]);
    end
    
    %Plot fundamental frequency in pairs of digits
    figure;
    for i = 1:2:numel(digits)
        digit1 = digits(i);
        digit2 = digits(i+1);
        
        [soundData1, sampleRate1] = loadRec(digit1, participant, 0);
        [soundData2, sampleRate2] = loadRec(digit2, participant, 0);

        Ts1 = 1/sampleRate1;
        Ts2 = 1/sampleRate2;

        N1 = length(soundData1);
        N2 = length(soundData2);

        T1 = N1*Ts1;
        T2 = N2*Ts2;

        N_frame = 1024;
        N_overlap = 512;

        subplot(5, 2, ceil(i/2));

        T_frame = N_frame*Ts1;
        T_overlap = N_overlap*Ts1;

        N1 = numel(soundData1);
        numFrames1 = floor((N1)/(N_frame - N_overlap));
        while N1 < (numFrames1-1)*(N_frame - N_overlap) + N_frame
            soundData1 = [soundData1; 0.];
            N1 = numel(soundData1);
        end

        if mod(N_frame, 2)==0
            f_frame = -sampleRate1/2:sampleRate1/N_frame:sampleRate1/2-sampleRate1/N_frame;
        else
            f_frame = -sampleRate1/2+sampleRate1/(2*N_frame):sampleRate1/N_frame - sampleRate1/2-sampleRate1/(2*N_frame);
        end

        f_frame = f_frame(floor(N_frame/2)+1:end);

        stft1 = [];

        for j = 0:numFrames1-1
            frameStart = j*(N_frame - N_overlap) + 1;
            frameEnd = frameStart + N_frame-1;
            frame = soundData1(frameStart:frameEnd);
            DFT_frame = fftshift(fft(frame));
            DFT_frame = DFT_frame(floor(N_frame/2)+1:end);
            mags_frame = abs(DFT_frame)/N_frame;
            stft1 = [stft1; mags_frame'];
        end

        fundamental_freqs1 = [];

        for j = 1:numFrames1
            index = find(stft1(j, :) == max(stft1(j, :)));
            fundamental_freqs1 = [fundamental_freqs1; f_frame(index)];
        end

        t1 = 0:T_frame-T_overlap:(numFrames1-1)*(T_frame-T_overlap);

        plot(t1, fundamental_freqs1, '-ob');
        hold on;

        N2 = numel(soundData2);
        numFrames2 = floor((N2)/(N_frame - N_overlap));
        while N2 < (numFrames2-1)*(N_frame - N_overlap) + N_frame
            soundData2 = [soundData2; 0.];
            N2 = numel(soundData2);
        end

        stft2 = [];

        for j = 0:numFrames2-1
            frameStart = j*(N_frame - N_overlap) + 1;
            frameEnd = frameStart + N_frame-1;
            frame = soundData2(frameStart:frameEnd);
            DFT_frame = fftshift(fft(frame));
            DFT_frame = DFT_frame(floor(N_frame/2)+1:end);
            mags_frame = abs(DFT_frame)/N_frame;
            stft2 = [stft2; mags_frame'];
        end

        fundamental_freqs2 = [];

        for j = 1:numFrames2
            index = find(stft2(j, :) == max(stft2(j, :)));
            fundamental_freqs2 = [fundamental_freqs2; f_frame(index)];
        end

        t2 = 0:T_frame-T_overlap:(numFrames2-1)*(T_frame-T_overlap);

        plot(t2, fundamental_freqs2, '-or');

        xlabel('t(s)');
        ylabel('Fundamental Freq (Hz)');
        ylim('auto');
        xlim('auto');

        title(['Fundamental Frequency Pairs - Digit Pair ', num2str(digit1), ' and ', num2str(digit2)]);
        legend(['Digit ', num2str(digit1)], ['Digit ', num2str(digit2)]);

        hold off;
    end
    
    %Plot fundamental frequency of each digit
    figure;
    for i = 1:numel(digits)
        digit = digits(i);
        [soundData, sampleRate] = loadRec(digit, participant, 0);
        Ts = 1/sampleRate;
        N = length(soundData);

        T = N*Ts;
        N_frame = 1024;
        N_overlap = 512;

        subplot(5, 2, i);

        T_frame = N_frame*Ts;
        T_overlap = N_overlap*Ts;

        N = numel(soundData);
        numFrames = floor((N)/(N_frame - N_overlap));
        while N < (numFrames-1)*(N_frame - N_overlap) + N_frame
            soundData = [soundData; 0.];
            N = numel(soundData);
        end

        

        if mod(N_frame, 2)==0
            f_frame = -sampleRate/2:sampleRate/N_frame:sampleRate/2-sampleRate/N_frame;
        else
            f_frame = -sampleRate/2+sampleRate/(2*N_frame):sampleRate/N_frame - sampleRate/2-sampleRate/(2*N_frame);
        end

        f_frame = f_frame(floor(N_frame/2)+1:end);

        stft = [];

        for j = 0:numFrames-1
            frameStart = j*(N_frame - N_overlap) + 1;
            frameEnd = frameStart + N_frame-1;
            frame = soundData(frameStart:frameEnd);
           
            DFT_frame = fftshift(fft(frame));
            DFT_frame = DFT_frame(floor(N_frame/2)+1:end);
            mags_frame = abs(DFT_frame)/N_frame;
            stft = [stft; mags_frame'];
        end

        fundamental_freqs = [];

        for j = 1:numFrames
            index = find(stft(j, :) == max(stft(j, :)));
            fundamental_freqs = [fundamental_freqs; f_frame(index)];
        end

        t = 0:T_frame-T_overlap:(numFrames-1)*(T_frame-T_overlap);

        plot(t, fundamental_freqs, '-ob');
        xlabel('t(s)');
        ylabel('Fundamental Freq (Hz)');
        ylim('auto');
        xlim('auto');
        title(['Fundamental Frequency - Digit ', num2str(digit)]);
    end
    
end
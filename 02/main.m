
%% ex1
participant = '02';

recording = input('Enter Recording: ', 's');

soundDataArray = cell(1, 10);
sampleRateArray = zeros(1, 10);

for i = 1 : 10
    disp(i);
    [soundData, sampleRate]  = loadRec(i-1, participant, recording);
    
    soundDataArray{i} = soundData;
    sampleRateArray(i) = sampleRate;

end

t = (0:length(soundDataArray{1})-1) / sampleRateArray(1,1); % Time vector

figure;

subplot(10, 1, 2);
plot(t, soundDataArray{1});
xlabel('Time (s)');
ylabel('Amplitude');
title('0');

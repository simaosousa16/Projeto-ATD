
%% ex1
participant = '02';

recording = input('Enter Recording: ', 's');

soundDataArray = cell(1, numFiles);
sampleRateArray = zeros(1, numFiles);

for i = 1 : 10
    disp(i);
    [soundData, sampleRate]  = loadRec(i-1, participant, recording);
    
    soundDataArray{i} = soundData;
    sampleRateArray(i) = sampleRate;

end

soundDataArray = cell2mat(data(:, 1));
sampleRateArray = cell2mat(data(:, 2));

plotRec(soundDataArray, sampleRateArray);

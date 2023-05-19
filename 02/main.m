
%% ex1
participant = '02';

recording = input('Enter Recording: ', 's');

data = cell(10, 2);  % Preallocate the cell array to store the results

for i = 1 : 10
    disp(i);
    [soundData, sampleRate]  = loadRec(i-1, participant, recording);
    
    data{i, 1} = soundData;  % Store the soundData value in the ith row, 1st column of the cell array
    data{i, 2} = sampleRate;  % Store the sampleRate value in the ith row, 2nd column of the cell array
end

soundDataArray = cell2mat(data(:, 1));
sampleRateArray = cell2mat(data(:, 2));

plotRec(soundDataArray, sampleRateArray);

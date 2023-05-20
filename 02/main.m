
participant = '02';

recording = input('Enter Recording: ', 's');

soundDataArray = cell(1, 10);
sampleRateArray = zeros(1, 10);

for i = 1 : 10
    disp(i);
    [soundData, sampleRate]  = loadRec(i-1, participant, str2double(recording));
    
    soundDataArray{i} = soundData;
    sampleRateArray(i) = sampleRate;

end



%% 4

plotRec4(soundDataArray,sampleRateArray);

%% 4.1

digito1 = input('digito 1: ', 's');
digito2 = input('digito 2: ', 's');


disp(digito1)
disp(digito2)
plotRec4_1(soundDataArray,sampleRateArray,str2double(digito1),str2double(digito2));

%% 4.2

plotEnergy(soundDataArray,sampleRateArray,1000);
calculateMeanSignals('02',50,length(soundDataArray{1}))

meanSignals = cell(1, 10);

for digit = 0:9
    filename = sprintf('mean_signal_digit_%02d.mat', digit);
    loadedData = load(filename);
    meanSignal = loadedData.data; % Assuming the mean signal variable in the file is named 'meanSignal'
    meanSignals{digit+1} = meanSignal;
end

%%

t = linspace(0,1,length(meanSignals{8}))
% Assuming t is the time vector and meanSignals is the cell array containing mean signals
figure;
plot(t, meanSignals{2});
xlabel('Time (s)');
ylabel('Amplitude');
title('Mean Signal for Digit 0');

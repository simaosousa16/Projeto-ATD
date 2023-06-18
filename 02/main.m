
participant = '02';

recording = input('Enter Recording: ', 's');

soundDataArray = cell(1, 10);
sampleRateArray = zeros(1, 10);

for i = 1 : 10
    [soundData, sampleRate]  = loadRec(i-1, participant, str2double(recording));
    soundDataArray{i} = soundData;
    sampleRateArray(i) = sampleRate;
end
plotRec4(soundDataArray,sampleRateArray);

%%
digits = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
energies = zeros(1, 10);
max_amplitudes = zeros(1, 10);

for i = 1:length(digits)
    [digit, fs] = loadRec(digits(i), participant, recording);
    energies(i) = sum(digit.^2);
    max_amplitudes(i) = max(abs(digit));
end

figure;
subplot(2, 1, 1);
bar(digits, energies);
title('Energia dos Dígitos');
xlabel('Dígito');
ylabel('Energia');

subplot(2, 1, 2);
bar(digits, max_amplitudes);
title('Amplitude Máxima dos Dígitos');
xlabel('Dígito');
ylabel('Amplitude Máxima');


%% 4.1

digito1 = input('digito 1: ', 's');
digito2 = input('digito 2: ', 's');


disp(digito1)
disp(digito2)
plotRec4_1(soundDataArray,sampleRateArray,str2double(digito1),str2double(digito2));

%% 4.2

plotEnergy(soundDataArray,sampleRateArray,200);
calculateMeanSignals('02',50,length(soundDataArray{1}))

meanSignals = cell(1, 10);

for digit = 0:9
    filename = sprintf('mean_signal_digit_%02d.mat', digit);
    loadedData = load(filename);
    meanSignal = loadedData.data; % Assuming the mean signal variable in the file is named 'meanSignal'
    meanSignals{digit+1} = meanSignal;
end

%%

digito = input('Enter Digito: ', 's');

envelope = calculateEnvelope(soundDataArray{str2double(digito)+1});
power = calculatePower(soundDataArray{str2double(digito)+1});
disp (power )
disp('Arquivo carregado:');

% Plot do power e da amplitude de envelope
t = (0:length(soundDataArray{str2double(digito)+1})-1) / sampleRateArray(str2double(digito)+1);

figure;
subplot(2, 1, 1);
plot(power);
title('Power do Sinal');
xlabel('Tempo (s)');
ylabel('Power');

subplot(2, 1, 2);
plot(t, envelope);
title('Amplitude de Envelope');
xlabel('Tempo (s)');
ylabel('Amplitude');

%%
t = linspace(0, 1, length(meanSignals{8}));



% Assuming t is the time vector and meanSignals is the cell array containing mean signals
mean_signal = meanSignals{str2double(digito) + 1};
[max_amp, max_idx] = max(mean_signal);
[min_amp, min_idx] = min(mean_signal);

disp("max_amp");
disp(max_amp);

disp(max(soundDataArray{str2double(digito) + 1}));
sound(meanSignals{str2double(digito) +1},sampleRateArray(str2double(digito) +1));

disp("min: ");
disp(min_amp);

figure;
plot(t, mean_signal);

xlabel('Time (s)');
ylabel('Amplitude');
title('Mean Signal');

hold on;
plot(t(max_idx), max_amp, 'ro', 'MarkerSize', 10);
plot(t(min_idx), min_amp, 'bo', 'MarkerSize', 10);
hold off;

legend('Mean Signal', 'Maximum Amplitude', 'Minimum Amplitude');

%%


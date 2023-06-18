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
%% 4.1

digito1 = input('digito 1: ', 's');
digito2 = input('digito 2: ', 's');


disp(digito1)
disp(digito2)
plotRec4_1(soundDataArray,sampleRateArray,str2double(digito1),str2double(digito2));
%%
% Step 1: Data Preparation
% Step 1: Data Preparation
participant = '02';
dados = getInfoForIF_ELSE(participant);
digito = input('Enter Digito: ', 's');
recording = input('Enter recording: ', 's');
[soundData, sampleRate] = loadRec(str2double(digito), participant, str2double(recording));
envelope = abs(soundData);
power = calculatePower(soundData);
% Additional feature extraction if needed

% Step 2: Feature Extraction
pertinent_value_1 = max(envelope);
pertinent_value_3 = mean(power);
% Adjust the feature extraction methods and values according to your requirements

% Step 3: Digit Identification
digit = NaN;  % Initialize digit to indicate no matching digit found
for i = 1:10
    if pertinent_value_1 > dados(i).per && pertinent_value_1 < dados(i).MaxPertinentValue1 && ...
       pertinent_value_3 > dados(i).MinPertinentValue3 && pertinent_value_3 < dados(i).MaxPertinentValue3
        digit = i-1;  % Assign the digit based on the index
        break;  % Exit the loop if a match is found
    end
end

% Step 4: Output
disp(digit);
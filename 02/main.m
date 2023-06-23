participant = '02';

recording = input('Enter Recording: ', 's');

soundDataArray = cell(1, 10);
sampleRateArray = zeros(1, 10);

for i = 1 : 10
    [soundData, sampleRate]  = loadRec(i-1, participant, str2double(recording));
    soundData = zeroPadding(soundData,max(sampleRate));
    soundDataArray{i} = soundData;
    sampleRateArray(i) = sampleRate;
end

plotRec4(soundDataArray,sampleRateArray);
%% 4.1
energia_pares();

%% 4.2 e 4.3
amplitudes_max = amplitudes_max();
amplitudes_medias = amplitudes_medias();
energias_medias = energias_medias();
n_picos_medios = numero_picos();

% Create a 3D scatter plot
figure
scatter3(energias_medias, n_picos_medios, amplitudes_max, 'o')

% Add text labels
text(energias_medias+0.02, n_picos_medios, amplitudes_max, {'0','1','2','3','4','5','6','7','8','9'})

% Set the labels for each axis
xlabel('Energia média')
ylabel('Número de picos')
zlabel('Amplitudes máximas')

% Set the title
title('Gráfico da energia média do envelope, número de picos do envelope e amplitudes máximas do envelope para cada digito')

%%
Ex5();

%%
Ex6();
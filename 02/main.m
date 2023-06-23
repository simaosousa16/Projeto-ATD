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

digito1 = input('digito 1: ', 's');
digito2 = input('digito 2: ', 's');


disp(digito1)
disp(digito2)
plotRec4_1(soundDataArray,sampleRateArray,str2double(digito1),str2double(digito2));
%%

amplitudes_max = amplitudes_max();
energias_medias = energias_medias();

n_picos_medios = numero_picos();

plot(energias_medias, n_picos_medios,"o");
text(energias_medias+.02, n_picos_medios, {'0','1','2','3','4','5','6','7','8','9'})
xlabel('Energia média do envelope');
ylabel('Número de picos do envelope');
title('Gráfico da energia médio do envelope pelo número de picos do envelope para cada digito');
%%


%%
Ex5();
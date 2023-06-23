function energia_pares()
    participant = '02';
    recordingsPerDigit = 50;  % Assuming there are 10 recordings per digit        
    energias = zeros(1, 10); % vetor com a energia media de cada dígito
    
    energias_martiz=zeros(10,50);
    count=0;

    for digit = 0:9

        disp(digit)
        disp(count)
        E = 0; %variavel da energia discreta
        
        for recording = 0:recordingsPerDigit-1

            [soundData, sampleRate] = loadRec(digit, participant, recording);
            soundData = zeroPadding(soundData,max(sampleRate));
            envelope = calculateEnvelope(soundData);

            E = sum(envelope.^2); %calcula a Energia media discreta do sinal
            
            energias_martiz(digit+1,recording+1)=E;
            
        end

        count=count+1;

        if count==2
           count=0;
	        
           str = sprintf('Pares  %d e %d', digit-1,digit);
           subplot(2,3,round((digit)/2))
           boxplot(energias_martiz');
           energias_martiz=zeros(10,50);
           ylabel('Energia');
           xlabel('Digitos');
           xticklabels({'0','1','2','3','4','5','6','7','8','9'})
            
           title(str)
           energias(digit+1) = 0;

        end

    end
end

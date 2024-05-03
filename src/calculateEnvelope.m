
function envelope = calculateEnvelope(signal)
    % Cálculo da amplitude de envelope
    envelope = abs(hilbert(signal));
    
    % Normalização da amplitude de envelope entre 0 e 1
    envelope = envelope / max(envelope);
end
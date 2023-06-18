function power = calculatePower(signal)
    % Cálculo do power
    power = (1 / numel(signal)) * sum(signal.^2);
end

function paddedSignal = zeroPadding(signal, targetSize)
    signalSize = length(signal);
    if signalSize >= targetSize
        paddedSignal = signal(1:targetSize);
    else
        padding = zeros(targetSize - signalSize, 1);
        paddedSignal = [signal; padding];
    end
end
clc;
clear;
close all;

%% ===================================
% OFDM WIRELESS COMMUNICATION SYSTEM
% COMPLETE BER SIMULATION
% ====================================

%% Configuration

M = 16;                 % 16-QAM
Nfft = 64;              % FFT size
cpLength = 16;         % Cyclic prefix
numOFDMsymbols = 100;  % OFDM symbols

SNR_dB = 0:5:20;       % SNR range

bitsPerSymbol = log2(M);

%% Result Storage

BER = zeros(size(SNR_dB));

%% ===================================
% DISPLAY CONFIGURATION
% ===================================

fprintf('===================================\n');
fprintf('OFDM WIRELESS COMMUNICATION SYSTEM\n');
fprintf('COMPLETE BER SIMULATION\n');
fprintf('===================================\n');

fprintf('Modulation       : %d-QAM\n', M);
fprintf('FFT size         : %d\n', Nfft);
fprintf('Cyclic prefix    : %d samples\n', cpLength);
fprintf('OFDM symbols     : %d\n', ...
    numOFDMsymbols);
fprintf('SNR range        : %d to %d dB\n', ...
    SNR_dB(1), SNR_dB(end));

%% ===================================
% SNR LOOP
% ===================================

for s = 1:length(SNR_dB)

    snr = SNR_dB(s);

    %% ===================================
    % TRANSMITTER
    % ===================================

    %% Generate random bits

    numQAMSymbols = ...
        Nfft * numOFDMsymbols;

    numBits = ...
        numQAMSymbols * bitsPerSymbol;

    txBits = randi([0 1], ...
        numBits, 1);

    %% ===================================
    % 16-QAM MODULATION
    % ===================================

    bitGroups = reshape( ...
        txBits, ...
        bitsPerSymbol, []).';

    symbolIndices = bi2de( ...
        bitGroups, 'left-msb');

    txQAM = qammod( ...
        symbolIndices, ...
        M, ...
        'UnitAveragePower', true);

    %% ===================================
    % OFDM MODULATION
    % ===================================

    ofdmGrid = reshape( ...
        txQAM, ...
        Nfft, ...
        numOFDMsymbols);

    %% IFFT

    ofdmTime = ifft( ...
        ofdmGrid, ...
        Nfft, 1);

    %% Add cyclic prefix

    cyclicPrefix = ...
        ofdmTime(end-cpLength+1:end, :);

    ofdmWithCP = ...
        [cyclicPrefix; ofdmTime];

    %% Serial signal

    txSignal = ofdmWithCP(:);

    %% ===================================
    % AWGN CHANNEL
    % ===================================

    signalPower = ...
        mean(abs(txSignal).^2);

    SNR_linear = ...
        10^(snr/10);

    noisePower = ...
        signalPower / SNR_linear;

    noise = sqrt(noisePower/2) * ...
        (randn(size(txSignal)) + ...
         1j*randn(size(txSignal)));

    rxSignal = ...
        txSignal + noise;

    %% ===================================
    % OFDM RECEIVER
    % ===================================

    %% Reshape received signal

    rxOFDM = reshape( ...
        rxSignal, ...
        Nfft + cpLength, ...
        numOFDMsymbols);

    %% Remove cyclic prefix

    rxWithoutCP = ...
        rxOFDM(cpLength+1:end, :);

    %% FFT

    rxQAMGrid = ...
        fft(rxWithoutCP, ...
        Nfft, 1);

    %% Convert to serial

    rxQAM = rxQAMGrid(:);

    %% ===================================
    % 16-QAM DEMODULATION
    % ===================================

    rxSymbolIndices = ...
        qamdemod( ...
            rxQAM, ...
            M, ...
            'UnitAveragePower', true);

    %% Convert symbols to bits

    rxBitGroups = ...
        de2bi( ...
            rxSymbolIndices, ...
            bitsPerSymbol, ...
            'left-msb');

    rxBits = ...
        rxBitGroups.';

    rxBits = rxBits(:);

    %% ===================================
    % BER CALCULATION
    % ===================================

    bitErrors = ...
        sum(txBits ~= rxBits);

    BER(s) = ...
        bitErrors / length(txBits);

    %% ===================================
    % DISPLAY RESULTS
    % ===================================

    fprintf('\n-----------------------------------\n');
    fprintf('SNR = %d dB\n', snr);
    fprintf('-----------------------------------\n');

    fprintf('Total bits : %d\n', ...
        length(txBits));

    fprintf('Bit errors : %d\n', ...
        bitErrors);

    fprintf('BER        : %.6e\n', ...
        BER(s));

end

%% ===================================
% FINAL RESULTS
% ===================================

fprintf('\n\n===================================\n');
fprintf('FINAL BER RESULTS\n');
fprintf('===================================\n');

fprintf('\nSNR (dB)        BER\n');
fprintf('-------------------------\n');

for s = 1:length(SNR_dB)

    fprintf('%6d       %.6e\n', ...
        SNR_dB(s), BER(s));

end

%% ===================================
% BER PLOT
% ===================================

figure;

semilogy(SNR_dB, BER, '-o', ...
    'LineWidth', 1.5);

xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');

title('OFDM Wireless Communication System - BER Performance');

grid on;

%% ===================================
% SAVE RESULTS
% ===================================

resultsDir = '../../results';

if ~exist(resultsDir, 'dir')
    mkdir(resultsDir);
end

save(fullfile(resultsDir, ...
    'ofdm_results.mat'), ...
    'SNR_dB', ...
    'BER', ...
    'M', ...
    'Nfft', ...
    'cpLength', ...
    'numOFDMsymbols');

fprintf('\n===================================\n');
fprintf('SIMULATION COMPLETED SUCCESSFULLY\n');
fprintf('===================================\n');

fprintf('Results saved to:\n');
fprintf('%s\n', ...
    fullfile(resultsDir, ...
    'ofdm_results.mat'));
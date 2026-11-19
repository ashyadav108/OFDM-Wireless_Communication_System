clc;
clear;
close all;

%% ===================================
% OFDM WIRELESS COMMUNICATION SYSTEM
% OFDM RECEIVER
% ====================================

%% Configuration

M = 16;                 % 16-QAM
Nfft = 64;              % FFT size
cpLength = 16;         % Cyclic prefix length
numOFDMsymbols = 100;  % Number of OFDM symbols

bitsPerSymbol = log2(M);

%% ===================================
% TRANSMITTER
% ===================================

numQAMSymbols = ...
    Nfft * numOFDMsymbols;

numBits = ...
    numQAMSymbols * bitsPerSymbol;

%% Generate random bits

txBits = randi([0 1], numBits, 1);

%% 16-QAM modulation

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
% OFDM TRANSMITTER
% ===================================

%% Arrange QAM symbols

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

%% Serial transmitted signal

txSignal = ofdmWithCP(:);

%% ===================================
% OFDM RECEIVER
% ===================================

%% Reshape received signal

rxOFDM = reshape( ...
    txSignal, ...
    Nfft + cpLength, ...
    numOFDMsymbols);

%% Remove cyclic prefix

rxWithoutCP = ...
    rxOFDM(cpLength+1:end, :);

%% FFT

rxQAMGrid = ...
    fft(rxWithoutCP, Nfft, 1);

%% Convert to serial QAM symbols

rxQAM = rxQAMGrid(:);

%% ===================================
% 16-QAM DEMODULATION
% ===================================

rxSymbolIndices = ...
    qamdemod( ...
        rxQAM, ...
        M, ...
        'UnitAveragePower', true);

%% Convert symbols back to bits

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

numBitErrors = ...
    sum(txBits ~= rxBits);

BER = ...
    numBitErrors / length(txBits);

%% ===================================
% DISPLAY RESULTS
% ===================================

fprintf('===================================\n');
fprintf('OFDM WIRELESS COMMUNICATION SYSTEM\n');
fprintf('OFDM RECEIVER\n');
fprintf('===================================\n');

fprintf('Modulation order     : %d-QAM\n', M);
fprintf('FFT size             : %d\n', Nfft);
fprintf('Cyclic prefix length : %d samples\n', cpLength);
fprintf('OFDM symbols         : %d\n', ...
    numOFDMsymbols);

fprintf('\nTransmitted bits     : %d\n', ...
    length(txBits));

fprintf('Received bits        : %d\n', ...
    length(rxBits));

fprintf('Bit errors           : %d\n', ...
    numBitErrors);

fprintf('BER                  : %.6f\n', ...
    BER);

if BER == 0
    fprintf('\nOFDM transmitter and receiver verified successfully.\n');
else
    fprintf('\nBit errors detected.\n');
end
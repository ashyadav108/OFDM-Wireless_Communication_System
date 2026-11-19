clc;
clear;
close all;

%% ===================================
% OFDM WIRELESS COMMUNICATION SYSTEM
% AWGN CHANNEL
% ====================================

%% Configuration

M = 16;                 % 16-QAM
Nfft = 64;              % FFT size
cpLength = 16;         % Cyclic prefix
numOFDMsymbols = 100;  % OFDM symbols

SNR_dB = 10;            % Channel SNR

bitsPerSymbol = log2(M);

%% ===================================
% TRANSMITTER
% ===================================

numQAMSymbols = ...
    Nfft * numOFDMsymbols;

numBits = ...
    numQAMSymbols * bitsPerSymbol;

%% Generate random bits

txBits = randi([0 1], ...
    numBits, 1);

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
% OFDM MODULATION
% ===================================

ofdmGrid = reshape( ...
    txQAM, ...
    Nfft, ...
    numOFDMsymbols);

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
    10^(SNR_dB/10);

noisePower = ...
    signalPower / SNR_linear;

noise = sqrt(noisePower/2) * ...
    (randn(size(txSignal)) + ...
     1j*randn(size(txSignal)));

rxSignal = ...
    txSignal + noise;

%% ===================================
% DISPLAY RESULTS
% ===================================

fprintf('===================================\n');
fprintf('OFDM WIRELESS COMMUNICATION SYSTEM\n');
fprintf('AWGN CHANNEL\n');
fprintf('===================================\n');

fprintf('Modulation order : %d-QAM\n', M);
fprintf('FFT size         : %d\n', Nfft);
fprintf('Cyclic prefix    : %d samples\n', cpLength);
fprintf('OFDM symbols     : %d\n', ...
    numOFDMsymbols);

fprintf('\nSNR                : %d dB\n', ...
    SNR_dB);

fprintf('Transmit power     : %.6e\n', ...
    signalPower);

fprintf('Noise power        : %.6e\n', ...
    noisePower);

fprintf('\nReceived signal generated successfully.\n');
fprintf('AWGN channel simulation completed.\n');
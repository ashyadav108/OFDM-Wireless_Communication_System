clc;
clear;
close all;

%% ===================================
% OFDM WIRELESS COMMUNICATION SYSTEM
% OFDM TRANSMITTER
% ====================================

%% Configuration

M = 16;                 % 16-QAM
Nfft = 64;              % FFT size
cpLength = 16;         % Cyclic prefix length
numOFDMsymbols = 100;  % Number of OFDM symbols

bitsPerSymbol = log2(M);

%% ===================================
% GENERATE RANDOM BITS
% ===================================

numQAMSymbols = ...
    Nfft * numOFDMsymbols;

numBits = ...
    numQAMSymbols * bitsPerSymbol;

txBits = randi([0 1], numBits, 1);

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
% ARRANGE QAM SYMBOLS
% INTO OFDM SYMBOLS
% ===================================

ofdmGrid = reshape( ...
    txQAM, ...
    Nfft, ...
    numOFDMsymbols);

%% ===================================
% IFFT
% ===================================

ofdmTime = ifft( ...
    ofdmGrid, ...
    Nfft, 1);

%% ===================================
% CYCLIC PREFIX
% ===================================

cyclicPrefix = ...
    ofdmTime(end-cpLength+1:end, :);

ofdmWithCP = ...
    [cyclicPrefix; ofdmTime];

%% ===================================
% CONVERT TO SERIAL SIGNAL
% ===================================

txSignal = ofdmWithCP(:);

%% ===================================
% DISPLAY RESULTS
% ===================================

fprintf('===================================\n');
fprintf('OFDM WIRELESS COMMUNICATION SYSTEM\n');
fprintf('OFDM TRANSMITTER\n');
fprintf('===================================\n');

fprintf('Modulation order     : %d-QAM\n', M);
fprintf('FFT size             : %d\n', Nfft);
fprintf('Cyclic prefix length : %d samples\n', cpLength);
fprintf('OFDM symbols         : %d\n', ...
    numOFDMsymbols);

fprintf('QAM symbols          : %d\n', ...
    numQAMSymbols);

fprintf('Input bits           : %d\n', ...
    numBits);

fprintf('Samples per OFDM     : %d\n', ...
    Nfft + cpLength);

fprintf('Total transmitted samples: %d\n', ...
    length(txSignal));

fprintf('\nAverage OFDM signal power: %.6f\n', ...
    mean(abs(txSignal).^2));

fprintf('\nOFDM transmitter completed successfully.\n');

%% ===================================
% TIME-DOMAIN OFDM SIGNAL
% ===================================

figure;

plot(real(txSignal(1:300)));

xlabel('Sample Index');
ylabel('Amplitude');

title('OFDM Transmitted Signal');

grid on;

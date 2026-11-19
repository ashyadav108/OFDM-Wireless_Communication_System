clc;
clear;
close all;

%% ===================================
% OFDM WIRELESS COMMUNICATION SYSTEM
% 16-QAM MODULATION
% ====================================

%% Configuration
M = 16;                 % 16-QAM
numSymbols = 1000;     % Number of QAM symbols

bitsPerSymbol = log2(M);

%% Generate Random Bits
numBits = numSymbols * bitsPerSymbol;

txBits = randi([0 1], numBits, 1);

%% Group Bits into Symbols
bitGroups = reshape(txBits, ...
    bitsPerSymbol, []).';

%% Convert Bits to Decimal Symbols
symbolIndices = bi2de( ...
    bitGroups, 'left-msb');

%% 16-QAM Modulation
txSymbols = qammod( ...
    symbolIndices, M, ...
    'UnitAveragePower', true);

%% Display Results

fprintf('===================================\n');
fprintf('OFDM WIRELESS COMMUNICATION SYSTEM\n');
fprintf('16-QAM MODULATION\n');
fprintf('===================================\n');

fprintf('Modulation order : %d-QAM\n', M);
fprintf('Bits per symbol  : %d\n', ...
    bitsPerSymbol);

fprintf('Number of bits   : %d\n', ...
    numBits);

fprintf('Number of symbols: %d\n', ...
    numSymbols);

fprintf('\nAverage symbol power: %.4f\n', ...
    mean(abs(txSymbols).^2));

fprintf('\n16-QAM modulation completed successfully.\n');

%% Constellation Plot

figure;

scatter(real(txSymbols), ...
    imag(txSymbols), ...
    20, 'filled');

xlabel('In-Phase');
ylabel('Quadrature');

title('16-QAM Constellation');

grid on;
axis equal;
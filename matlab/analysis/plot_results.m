clc;
clear;
close all;

%% ===================================
% OFDM WIRELESS COMMUNICATION SYSTEM
% RESULT ANALYSIS
% ====================================

resultsFile = '../../results/ofdm_results.mat';

%% Check result file

if ~exist(resultsFile, 'file')
    error('Results file not found. Run ofdm_simulation.m first.');
end

%% Load results

load(resultsFile);

fprintf('===================================\n');
fprintf('OFDM WIRELESS COMMUNICATION SYSTEM\n');
fprintf('RESULT ANALYSIS\n');
fprintf('===================================\n');

fprintf('Results loaded successfully.\n');

%% ===================================
% DISPLAY BER RESULTS
% ===================================

fprintf('\nSNR (dB)        BER\n');
fprintf('-------------------------\n');

for s = 1:length(SNR_dB)

    fprintf('%6d       %.6e\n', ...
        SNR_dB(s), BER(s));

end

%% ===================================
% BER PERFORMANCE PLOT
% ===================================

figure;

semilogy(SNR_dB, BER, '-o', ...
    'LineWidth', 1.5);

xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');

title('OFDM Wireless Communication System - BER Performance');

grid on;

%% ===================================
% PERFORMANCE OBSERVATIONS
% ===================================

fprintf('\n===================================\n');
fprintf('KEY PERFORMANCE OBSERVATIONS\n');
fprintf('===================================\n');

fprintf('\nBER decreases as SNR increases.\n');

fprintf('At 0 dB SNR  : BER = %.6e\n', ...
    BER(1));

fprintf('At 5 dB SNR  : BER = %.6e\n', ...
    BER(2));

fprintf('At 10 dB SNR : BER = %.6e\n', ...
    BER(3));

fprintf('At 15 dB SNR : BER = %.6e\n', ...
    BER(4));

fprintf('At 20 dB SNR : BER = %.6e\n', ...
    BER(5));

fprintf('\nThe system becomes more reliable as the\n');
fprintf('signal-to-noise ratio increases.\n');

fprintf('\n===================================\n');
fprintf('ANALYSIS COMPLETED SUCCESSFULLY\n');
fprintf('===================================\n');
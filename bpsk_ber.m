% BER in the BPSK system (Baseband signals)
%------------------------------------------------------------
clear all; close all; %#ok<CLALL>
% clear previous data and close windows
%------------------------------------------------------------
% Configure Input parameters:
fprintf("\nInput parameters:\n")
% 1 - num of data bits to transfer through the channel: 
num_ch_bits = [5*10^3, 10^4, 5*10^4, 10^5, 5*10^5, 10^6, 5*10^6, 10^7];
fprintf(['Num of data bits to transfer through the channel =' ...
    repmat(' %g',1,numel(num_ch_bits))], num_ch_bits)
fprintf("\n")
% 2 - Signal-to-noise ratio in the channel - determined by AWGN level:
SNR = [-4, -2, 0, 2, 4, 6, 8, 10, 12]; % array of SNRs (dB)
fprintf(['SNR (dB) =' repmat(' %.1f',1,numel(SNR))], SNR)
fprintf("\n")

%% BITS LOOP - repeats the simulation for each element of num_ch_bits array
BER_dB_all = zeros(length(num_ch_bits),length(SNR)); % Stores results
for iter1 = 1: 1: length(num_ch_bits) 
    fprintf('\n* BPSK simulation *\n')
    fprintf('Number of bits: %g \n', num_ch_bits(iter1))
    % Generate random data bits for transfer
    % TODO: add input for some standard signaals
    channel_bits = randn(1, num_ch_bits(iter1)) >= 0; 
    % random array of -1 and 1
    % condition >=0 turns this array into a 0 and 1 array
    %------------------------------------------------------------
    % Other data
    A = 1; % Signal amplitude on Connection line
    %------------------------------------------------------------
    % Form signal that's sent through the coded channel
     bpsk_coded_signal = A*(2*channel_bits - 1); 
    %------------------------------------------------------------
    % SNR LOOP  - calculates BER for every element of SNR array
    BER = 1:length(SNR); % BER and SNR have equal array lengths
    BER_dB = 1:length(SNR);
    for iter2 = 1: 1: length(SNR) 
    %   for every element of BER array execute 1 iteration of the for loop
    %------------------------------------------------------------
    %   Connection line - adding Gaussian noise:
        EbN0 = 10^(SNR(iter2)/10); % 
        AWGN_sigma = sqrt(1/(EbN0*2));
        AWGN = AWGN_sigma * randn(1, length(bpsk_coded_signal));
        received_signal = bpsk_coded_signal + AWGN;
        % Decider's output
        bpsk_decoded_bits = received_signal >= 0;
    %---------------------------------------------------------------
    %   Received bits with error:
        difference = (channel_bits) - (bpsk_decoded_bits);
    %   Num of errors and received bits in curr. iteration:
        tot_err = sum(abs(difference));
        tot_bits = length(bpsk_coded_signal);
        BER(iter2) = tot_err / tot_bits; % BER for current SNR
        BER_dB(iter2) = log10(BER(iter2)); % BER (dB) for current SNR
        fprintf('BER = %f for SNR = %.1f \n',BER_dB(iter2), SNR(iter2));
    end
    % Store for plot
    BER_dB_all(iter1, :) = BER_dB;
end
%------------------------------------------------------------
%% Theoretical BER
BER_theory = 0.5*erfc(sqrt(10.^(SNR/10)));
BER_theory_dB = log10(BER_theory); % Theoretical BER (formula)
%------------- 
%% Plot BER vs SNR
figure('Name','BER vs SNR','NumberTitle','off');
plot(SNR, BER_dB_all, 'o', 'MarkerSize',6);
hold on;  grid on;
plot(SNR, BER_theory_dB, 'b', 'LineWidth',1);
xlabel('SNR per bit (E_b/N_0) [dB]'); ylabel('BER [dB]');
title('BER for BPSK coding in channel with AWGN');
legend_items = strings(1, length(num_ch_bits)+1);
for iter = 1:1:length(num_ch_bits)
    legend_items(iter) = sprintf("Simulated %g",num_ch_bits(iter));
end
legend_items(length(num_ch_bits)+1) = "Theoretical";
lgd = legend(legend_items, 'Location','best');
%lgd = legend(repelem(["Simulated", "Theoretical"], [length(num_ch_bits) 1]), 'Location','best');
legend('boxoff')
title(lgd,'BER plots')
%--THE-END-------------------------------------------------------
% BER in the BPSK system
% (Baseband)
%------------------------------------------------------------
clear all; close all; %#ok<CLALL>
% clear previous data and close windows
%------------------------------------------------------------
fprintf('\n BPSK simulation \n')
%------------------------------------------------------------
% Initialization
% 1 - num of data bits to transfer through the channel: 
num_ch_bits = 1000000;
fprintf('BPSK - num of data bits to transfer through the channel: %d \n', num_ch_bits)
% 2 - Signal-to-noise ratio in the channel - determined by AWGN level:
SNR = -10:2:10; % array of SNRs (dB)
%----------------------------------------------------------
% Generate random data bits for transfer
% TODO: add input for some standard signaals
channel_bits = randn(1, num_ch_bits) >= 0; 
% random array of -1 and 1
% condition >=0 turns this array into a 0 and 1 array
%------------------------------------------------------------
% Other data
A = 1; % Signal amplitude on Connection line
%------------------------------------------------------------
% Form signal that's sent through the coded channel
 bpsk_coded_signal = A*(2*channel_bits - 1); 
%------------------------------------------------------------
% Main simulation for loop
% calculates BER for every element of SNR array
BER = 1:length(SNR); % BER and SNR have equal array lengths
BER_dB = 1:length(SNR);
indx = 1; % first element of BER array
for snr = 1: 1: length(SNR) 
%   for every element of BER array execute 1 iteration of the for loop
%------------------------------------------------------------
%   Connection line - adding Gaussian noise:
    EbN0 = 10^(SNR(snr)/10); % 
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
    BER(indx) = tot_err / tot_bits; % BER for current SNR
    BER_dB(indx) = log10(BER(indx)); % BER (dB) for current SNR
    fprintf('BER = %f za SNR = %d \n',BER_dB(indx), SNR(snr));
    indx = indx + 1; % next element of BER array
 end
%------------------------------------------------------------
BER_theory = 0.5*erfc(sqrt(10.^(SNR/10))); % Theoretical BER (formula)
BER_theory_dB = log10(BER_theory); % Theoretical BER (formula)
%------------- 
% Plot BER (dB)
figure(1);
plot(SNR, BER_dB, 'ob', 'MarkerSize',5, 'MarkerFaceColor',[0.4,0.4,0.4]);
hold on;  grid on;
plot(SNR, BER_theory_dB, 'b', 'LineWidth',1.2);
xlabel('SNR per bit (E_b/N_0) [dB]'); ylabel('BER [dB]');
title('BER for BPSK coding in channel with AWGN');
legend('Simulated BER', 'Theoretical BER');
%--THE-END-------------------------------------------------------
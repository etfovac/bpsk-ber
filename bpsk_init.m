function [data_bits, t, Ts, Tb, bpsk_coded_signal, Carrier] = bpsk_init(num_data_bits, SNR, F_carrier, reset, print)
%BPSK_INIT Summary of this function goes here
% 
if(reset)
    close all; % close figure windows
end
if(print)
    fprintf('\n* BPSK simulation *\n')
    fprintf('Number of data bits: %d \n', num_data_bits)
    fprintf('SNR (dB): %.1f \n', SNR)
end
%----------------------------------------------------------
% Generate random data bits for transfer
% >> TODO: add input for some standard signals
data_bits = randn(1, num_data_bits) >= 0;
% random array of -1 and 1
% condition >=0 turns this array into a 0 and 1 array
%------------------------------------------------------------
% Other data
Rb = 1000; % Bit rate
% Rb = speed (rate) of bits per sec = Fm (max signal frequency in spectrum)
A = 1; % Signal amplitude on Connection line
num_samples_per_bit = 20; % = Tb/Ts; (taken at will, has to be >= 2)
Fs = num_samples_per_bit * Rb;  % Sampling frequency (Hz)
Ts=1/Fs; % Sample duration (sec)
Tb=1/Rb; % Bit duration (sec)
t = 0 : Ts : Tb * num_data_bits - Ts; % Time axis
%------------------------------------------------------------
% Form signal that's sent through the coded channel
bpsk_coded_bit = zeros(1,Tb*1/Ts);
bpsk_coded_signal = zeros(1,num_data_bits*length(bpsk_coded_bit));
% signal is 'spread' (sampled) during each data bit duration
for cntr = 1 : num_data_bits
    bpsk_coded_bit = A*(2*data_bits(cntr) - 1) *ones(1,num_samples_per_bit);
    % values are -A are +A, i.e. -1 and +1 (phase change 0 and pi)
    bpsk_coded_signal((cntr-1)*num_samples_per_bit +1 : (cntr)*num_samples_per_bit) = bpsk_coded_bit;
end
%F_carrier = 500; % Carrier frequency (Hz) (set at will)
Carrier = cos(2*pi*F_carrier*t);
end


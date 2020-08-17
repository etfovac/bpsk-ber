%  BPSK system
%------------------------------------------------------------
clear all; close all; %#ok<CLALL>
% clear previous data and close windows
%------------------------------------------------------------
fprintf('\n BPSK simulation \n')
%------------------------------------------------------------
% Initialization
% 1 - num of data bits to transfer: 
num_data_bits = 16;
fprintf('BPSK - num of data bits to transfer: %d \n', num_data_bits)
% 2 - Signal-to-noise ratio in the channel - determined by AWGN level:
SNR = 0; %:2:10; % SNR (dB) range
% TODO: add looping
fprintf('BPSK - SNR: %d \n', SNR)
%----------------------------------------------------------
% Generate random data bits for transfer
% TODO: add input for some standard signaals
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
%---------
% Plots
figure(1)
subplot(4,1,1); stem(data_bits);
xlabel('Bits'); ylabel('Logical values'); title('Input data bits');
axis([0, num_data_bits, -0.5, 1.5]);
subplot(4,1,2); plot(t, bpsk_coded_signal, 'LineWidth',2); grid on;
xlabel('Time'); ylabel('Amplitude'); title('Coded signal');
maxTime=max(t); 
maxAmp=max(bpsk_coded_signal);
minAmp=min(bpsk_coded_signal);
axis([0,maxTime,minAmp-0.5,maxAmp+0.5]);
%------------------------------------------------------------
% Transmitter TX - Frequency multiplier
F_carrier = 500; % Carrier frequency (Hz) (set at will)
% TODO: add as input
Carrier = cos(2*pi*F_carrier*t);
% Frequency multiplier output
bpsk_modulated_signal = bpsk_coded_signal .* Carrier; 
%---------
% Plot
subplot(4,1,3); plot(t, bpsk_modulated_signal, 'LineWidth',2.5); grid on;
xlabel('Time'); ylabel('Amplitude'); title('Modulated signal');
maxTime=max(t); 
maxAmp=max(bpsk_modulated_signal);
minAmp=min(bpsk_modulated_signal);
axis([0,maxTime,minAmp-0.5,maxAmp+0.5]);
%---------------------------------------------------------------
% Line/channel 
EbN0 = 10^(SNR/10); % 
AWGN_sigma = sqrt(1/(EbN0*2));
AWGN = AWGN_sigma * randn(1, length(bpsk_modulated_signal));
%---------
% Plot
subplot(4,1,4); plot(t, AWGN, 'LineWidth',2); grid on;
xlabel('Time'); ylabel('Amplitude'); title('White Gaussian noise');
maxTime=max(t); 
maxAmp=max(AWGN);
minAmp=min(AWGN);
axis([0,maxTime,minAmp-0.5,maxAmp+0.5]);
% Adding Gaussian noise:
received_signal = bpsk_modulated_signal + AWGN; 
%---------------------------------------------------------------
% Receiver RX - Frequency multiplier (synchronous demodulation)
Rx_fmultiplier_output = received_signal .* Carrier; 
%---------------------------------------------------------------
% Receiver RX - Integrator
interval = 0 : Ts : Tb-Ts; 
% integration boundaries define Tb (data bit duration)
Integrator_output = zeros(1,(length(Rx_fmultiplier_output)/(Tb/Ts)));
% (length(Rx_fmultiplier_output)/(Tb/Ts)) == num_data_bits
for i = 0 : (length(Rx_fmultiplier_output)/(Tb/Ts))-1  % num of bits
     Integrator_output(i+1) = trapz(interval, Rx_fmultiplier_output( (i*(Tb/Ts)+1) : ((i+1)*(Tb/Ts))) );
end
% trapz does numerical integration using trapezoidal method
% on data bit duration interval
%------------------------------------------------------------
% Receiver RX - Odlucivac - Treshold
% 0 is Treshold, decision: 0 for -1, 1 for 1
Decider_output = (Integrator_output >= 0); 
% Decider_output yealds received data bits
%---------
% Plot
figure(2)
subplot(4,1,1); plot(t, received_signal, 'LineWidth',2); grid on;
xlabel('Time'); ylabel('Amplitude'); title('Receiver RX');
maxTime=max(t); 
maxAmp=max(received_signal);
minAmp=min(received_signal);
axis([0,maxTime,minAmp-1,maxAmp+1]);  
subplot(4,1,2); plot(t, Rx_fmultiplier_output, 'LineWidth',2); grid on;
xlabel('Time'); ylabel('Amplitude'); title('RX F.Multiplier output');
maxTime=max(t); 
maxAmp=max(Rx_fmultiplier_output);
minAmp=min(Rx_fmultiplier_output);
axis([0,maxTime,minAmp-1,maxAmp+1]);  
subplot(4,1,3); stem(Integrator_output, 'MarkerFaceColor',[0.4,0.4,1]);
grid on; xlabel('Bits'); ylabel('Amplitude'); title('Integrator output');
subplot(4,1,4); stem(Decider_output);
xlabel('Bits'); ylabel('Logical values'); title('Received data bits');
axis([0, num_data_bits, -0.5, 1.5]); 
%--THE-END-------------------------------------------------------
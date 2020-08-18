# bpsk-ber [![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/etfovac/bpsk-ber/blob/master/LICENSE) [![GitHub (pre-)release](https://img.shields.io/badge/release-1.0-yellow.svg)](https://github.com/etfovac/bpsk-ber/releases/tag/v1.0)

### Keywords:

> BPSK,	Binary Phase Shift Keying

> AWGN, Additive white Gaussian noise	 

> SNR, Signal to Noise Ratio

> BER,	Bit Error Rate, POE, Probability Of Error

> Digital Signal processing


## Basic Overview
In digital phase modulation, the bits that need to be transmitted are coded in the carrier phase change.  
The simplest phase modulation, called Binary Phase Shift Keying (BPSK), uses two phases to encode two binary digits.  

The BPSK modulator is implemented using an input data set (0 and 1) which is sent to the input of the BPSK encoder which has assigned voltages of -1V and + 1V to this bit sequence. The encoder output is multiplied by the carrier cosine signal.
The integrator works as a low-pass filter and removes harmonics caused by multiplying the received signal by the carrier signal. The output of the integrator is led to a threshold detector which at the output reconstructs through 0 and 1.
If the signal strength is sufficiently greater than the noise power at the link line, this detected bit string will be identical to the one sent.  

MATLAB simulation that mathematically models the process of determining BER performs the following:
1. Creating BPSK symbols +1 and -1 from a randomly generated bit sequence (given length)
2. Adding white (Gaussian) noise (for a given difference between signal level and noise)
3. Detection of the received signal based on the reception threshold
4. Counting errors and drawing BER graphics

For the assessment of BER, BPSK coding in the basic frequency range was used, ie. modulation and demodulation were not simulated (moving the signal to a higher frequency, then back to baseband) due to the faster execution of the simulation and because the results are the same in both cases.




### Flowchart
<img src="https://github.com/etfovac/bpsk-ber/blob/master/graphics/bpsk_system.png" alt="bpsk_system">  
<img src="https://github.com/etfovac/bpsk-ber/blob/master/graphics/bpsk_signal.png" alt="bpsk_signal">  

bit 1: 	s(t) = A cos(2πfct)    = +A cos(2πfct)   
bit 0: 	s(t) = A cos(2πfct+ π) = -A cos(2πfct)   

s(t) =  A d(t) cos(2πfct)   

r(t) = s(t) + n(t)   

<img src="https://github.com/etfovac/bpsk-ber/blob/master/graphics/bpsk_snr_formula.png" alt="bpsk_snr_formula" width="150" height="50">  
<img src="https://github.com/etfovac/bpsk-ber/blob/master/graphics/bpsk_ber_formula.png" alt="bpsk_ber_formula" width="150" height="50">

### Results
<img src="https://github.com/etfovac/bpsk-ber/blob/master/graphics/bpsk_system_fig1.png" alt="bpsk_system_fig1">  
<img src="https://github.com/etfovac/bpsk-ber/blob/master/graphics/bpsk_system_fig2.png" alt="bpsk_system_fig2">  
<img src="https://github.com/etfovac/bpsk-ber/blob/master/graphics/bpsk_ber_fig1.png" alt="bpsk_ber_fig1">  

```  
BPSK simulation  
 BPSK - num of data bits to transfer through the channel: 1000000  
 BER = -0.484644 za SNR = -10  
 BER = -0.542406 za SNR = -8  
 BER = -0.622411 za SNR = -6  
 BER = -0.731174 za SNR = -4  
 BER = -0.884889 za SNR = -2  
 BER = -1.105961 za SNR = 0  
 BER = -1.425159 za SNR = 2  
 BER = -1.902257 za SNR = 4  
 BER = -2.618704 za SNR = 6  
 BER = -3.782516 za SNR = 8  
 BER = -5.301030 za SNR = 10  
``` 
### Conclusion
The probability of incorrect bit detection (BER) is practically lost for a large SNR and is of the order of 1/N (1 bit in the sequence).  
All BER curves follow the theoretical BER curve with small deviations.  
Therefore, the BER does not depend on the number of bits transmitted.  
The minimum SNR for which BPSK has 1 bit error depends on the total transmitted bits, so that for a larger number of transmitted bits, the SNR must be higher for the signal to be correctly reconstructed.  
For example. when transmitting 100 bits, it is enough for the SNR to exceed 4 dB so that there is no transmission error, while for the transmission of 100,000 bits, the SNR must exceed 8 dB.  

function signal_time_plots(sel_fig, time, sig1, sig2, sig3, sig4)
%SIGNAL_PLOTS Summary of this function goes here
%  
    if(contains(sel_fig, 'Input Signals'))
        figure('Name',sel_fig,'NumberTitle','off');
        % Plot 1
        subplot(4,1,1); stem(sig1);
        xlabel('Bits'); ylabel('Logical values'); title('Input data bits');
        axis([0, length(sig1), -0.5, 1.5]);
        % Plot 2
        subplot(4,1,2); plot(time, sig2, 'LineWidth',2); grid on;
        xlabel('Time'); ylabel('Amplitude'); title('Coded signal');
        maxTime=max(time);
        maxAmp=max(sig2);
        minAmp=min(sig2);
        axis([0,maxTime,minAmp-0.5,maxAmp+0.5]);
        % Plot 3
        subplot(4,1,3); plot(time, sig3, 'LineWidth',2.5); grid on;
        xlabel('Time'); ylabel('Amplitude'); title('Modulated signal');
        maxTime=max(time); 
        maxAmp=max(sig3);
        minAmp=min(sig3);
        axis([0,maxTime,minAmp-0.5,maxAmp+0.5]);
        % Plot 4
        subplot(4,1,4); plot(time, sig4, 'LineWidth',2); grid on;
        xlabel('Time'); ylabel('Amplitude'); title('White Gaussian noise');
        maxTime=max(time); 
        maxAmp=max(sig4);
        minAmp=min(sig4);
        axis([0,maxTime,minAmp-0.5,maxAmp+0.5]);
    elseif(contains(sel_fig, 'Output Signals'))
        figure('Name',sel_fig,'NumberTitle','off');
        % Plot 1
        subplot(4,1,1); plot(time, sig1, 'LineWidth',2); grid on;
        xlabel('Time'); ylabel('Amplitude'); title('Receiver RX');
        maxTime=max(time); 
        maxAmp=max(sig1);
        minAmp=min(sig1);
        axis([0,maxTime,minAmp-1,maxAmp+1]); 
        % Plot 2
        subplot(4,1,2); plot(time, sig2, 'LineWidth',2); grid on;
        xlabel('Time'); ylabel('Amplitude'); title('RX F.Multiplier output');
        maxTime=max(time); 
        maxAmp=max(sig2);
        minAmp=min(sig2);
        axis([0,maxTime,minAmp-1,maxAmp+1]); 
        % Plot 3
        subplot(4,1,3); stem(sig3, 'MarkerFaceColor',[0.4,0.4,1]);
        grid on; xlabel('Bits'); ylabel('Amplitude'); title('Integrator output');
        minAmp=min(sig3);
        maxAmp=max(sig3);
        axis([0, length(sig3), minAmp*1.5, maxAmp*1.5]);
        % Plot 4
        subplot(4,1,4); stem(sig4);
        xlabel('Bits'); ylabel('Logical values'); title('Received data bits');
        axis([0, length(sig4), -0.5, 1.5]);
    end
end


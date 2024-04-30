function [maxf, idx] = fftsample(data, freq,p)
Fs = freq;            % Sampling frequency                    
X = [data]; %Data

%%
L = length(X);          
T = 1/Fs;     
t = (0:L-1)*T;        

Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

[maxp,idx] = max(P1(f>=0 & f<100)); %limit the freq here
temp = f(f>=0 & f<100); %and here
maxf = temp(idx);
%% do you want the fft plot?
if p ==1
    figure(23)
    clf(23)
    plot(f.*60,P1,'.-');
    grid on
    box on
    xlabel('RPM')
    ylabel('|P1(f)|')
end
%% 第7课：FFT双边幅度谱、连续傅里叶积分近似（仅需 MATLAB）
clear;
close all;
clc;

fs = 100;
N = 500;
t = (0:N-1).'/fs;
x = cos(2*pi*2*t)+0.5*cos(2*pi*8*t);
X = fft(x);
f = (-N/2:N/2-1).'*fs/N;
amplitude = abs(fftshift(X))/N;       % 双边谱，不是单边谱

fct = linspace(-10,10,1001).';        % Hz，本例包含零频率点
wct = 2*pi*fct;                      % 转成rad/s进入指数
Xct = (1/fs)*exp(-1i*(wct*t.'))*x;   % 连续变换的矩形求积近似

figure('Name','Lesson 7');
subplot(3,1,1); plot(t,x); grid on; title('Input'); xlabel('t / s');
subplot(3,1,2); plot(f,amplitude); xlim([-10 10]); grid on;
title('DFT two-sided amplitude'); xlabel('f / Hz');
subplot(3,1,3); plot(fct,abs(Xct)); grid on;
title('Continuous-transform approximation'); xlabel('f / Hz');

% 验证：双边谱在+-2Hz高度0.5，在+-8Hz高度0.25。
% Parseval：sum(abs(x).^2)=sum(abs(X).^2)/N。
% 两种谱的缩放不同：DFT幅度除N；积分近似乘dt。
% 练习：将2Hz改为2.13Hz，观察有限记录造成的谱泄漏。

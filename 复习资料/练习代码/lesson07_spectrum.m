%% 第7课：FFT双边幅度谱、连续傅里叶积分近似（仅需 MATLAB；同目录需要 prefourier.m）
clear;
close all;
clc;

fs = 100;
N = 500;
Trg = [0 N/fs];
OMGrg = 2*pi*[-10 10];
K = 1001;
[t,omg,FT,~] = prefourier(Trg,N,OMGrg,K);
x = cos(2*pi*2*t)+0.5*cos(2*pi*8*t);
X = fft(x);
f = (-N/2:N/2-1).'*fs/N;
amplitude = abs(fftshift(X))/N;       % 双边谱，不是单边谱

fct = omg/(2*pi);                     % 将课件函数的 rad/s 转成 Hz
Xct = FT*x;                           % 调用课件函数建立的连续变换矩阵

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

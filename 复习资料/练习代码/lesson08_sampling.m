%% 第8课：混叠与先滤波后抽取（仅需 MATLAB）
clear;
close all;
clc;

% 20Hz采样下，cos(2*pi*77*n/20)=cos(2*pi*3*n/20)。
fsAlias = 20;
ta = (0:19)/fsAlias;
s3 = 1+cos(2*pi*3*ta);
s77 = 1+cos(2*pi*77*ta);

% 汇总第3页的离散低通系统，100Hz采样包含40Hz与5Hz分量。
fs = 100;
t = (0:60)/fs;                      % 本题包含0.6秒端点
x = sin(80*pi*t)+sin(10*pi*t);
a = [1 0 0.17];
b = [0.3 0.6 0.3];
L = 2;
xf = filter(b,a,x);
y_before = xf(1:L:end);            % 先滤波再抽取
xd = x(1:L:end);
y_after = filter(b,a,xd);           % 先抽取再滤波，通常不等价
td = t(1:L:end);
fs_new = fs/L;

figure('Name','Lesson 8');
subplot(3,1,1); stem(ta,s3); hold on; plot(ta,s77,'rx'); grid on;
legend('3 Hz','77 Hz'); title('Same samples at fs=20 Hz'); xlabel('t / s');
subplot(3,1,2); stem(td,y_before); grid on;
title('Filter then keep every 2nd sample'); xlabel('t / s');
subplot(3,1,3); stem(td,y_after); grid on;
title('Keep every 2nd sample then filter'); xlabel('t / s');

% 新采样率为50Hz；40Hz会混叠到10Hz，抽取后无法靠低通恢复原频率。
% 这里的给定滤波器只用于对比，不保证理想抗混叠性能。
% decimate通常还包含抗混叠处理，不能与x(1:L:end)完全等同。
% 练习：检查numel(td)、numel(y_before)、numel(y_after)是否一致。

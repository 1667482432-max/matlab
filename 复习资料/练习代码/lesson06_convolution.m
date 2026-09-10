%% 第6课：离散卷积、连续卷积近似（仅需 MATLAB；同目录需要 conv1.m）
clear;
close all;
clc;

xd = [1 2 1];
hd = [1 -1];
yd = conv(xd,hd);                      % 精确结果[1 1 -1 -1]
nd = 0:numel(yd)-1;
L = numel(xd)+numel(hd)-1;
yfft = real(ifft(fft(xd,L).*fft(hd,L)));

dt = 0.001;
t = 0:dt:8;
x = double((t>=0)&(t<2));
h = exp(-t);
[y,ty] = conv1(x,t,h,t);               % 课件函数内部计算 dt*conv(x,h)
reference = zeros(size(ty));
idx = ty<2;
reference(idx) = 1-exp(-ty(idx));
reference(~idx) = exp(-(ty(~idx)-2))-exp(-ty(~idx));

figure('Name','Lesson 6');
subplot(2,1,1); stem(nd,yd); grid on;
title('Discrete convolution'); xlabel('n');
subplot(2,1,2); plot(ty,y,ty,reference,'--'); grid on;
legend('Numerical','Infinite-support analytic');
title('Continuous convolution approximation'); xlabel('t / s'); xlim([0 8]);

% 解析参考使用无限长h，本代码在8秒截断；图只比较0至8秒。
% 验证：离散卷积长度为3+2-1=4；yfft与yd相同。
% 连续数值曲线有步长误差，不要求与解析式逐位相等。
% 练习：把 dt 改为 0.002，再观察连续卷积近似的误差量级。

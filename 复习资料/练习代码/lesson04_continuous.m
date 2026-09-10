%% 第4课：连续系统响应（Control System Toolbox）
% 对应考题：y'' + 1.2*y' + y = x' + x，零初始状态，x 为 0<=t<2 的矩形。
% 分子系数 [1 1] 对应 x' + x；分母系数 [1 1.2 1] 对应 y'' + 1.2*y' + y。
clear;
close all;
clc;

dt = 0.01;
t = (0:dt:10).';
x = double((t >= 0) & (t < 2));

% 用传递函数表示系统：H(s) = (s+1)/(s^2+1.2s+1)
sys = tf([1 1], [1 1.2 1]);

% 零状态响应：将矩形输入 x(t) 送进系统，得到 y(t)。
y = lsim(sys, x, t);

% 分别以单位冲激、单位阶跃作为输入，观察系统本身的两种标准响应。
h = impulse(sys, t);
g = step(sys, t);

figure('Name', 'Lesson 4');
subplot(2,2,1); plot(t, x, 'LineWidth', 1.2); grid on;
title('Input x(t)'); xlabel('t / s'); ylabel('x(t)');
subplot(2,2,2); plot(t, y, 'LineWidth', 1.2); grid on;
title('Zero-state response y(t)'); xlabel('t / s'); ylabel('y(t)');
subplot(2,2,3); plot(t, h, 'LineWidth', 1.2); grid on;
title('Impulse response h(t)'); xlabel('t / s'); ylabel('h(t)');
subplot(2,2,4); plot(t, g, 'LineWidth', 1.2); grid on;
title('Step response g(t)'); xlabel('t / s'); ylabel('g(t)');

% 自查：h(0+) 约为 1；g(0)=0；g(t) 最终趋近 1；
% 矩形输入结束后，零状态响应 y(t) 最终衰减至 0。

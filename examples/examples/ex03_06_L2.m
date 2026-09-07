clear;
close all;
clc;


% ex03_06_L2.m  |  例3.6 · L2 引导求解  |  AI 生成，已校验，R2023b
% 连续LTI系统的冲激响应与阶跃响应
% 系统微分方程：i''(t)+7i'(t)+10i(t)=e''(t)+6e'(t)+4e(t)
% 输入 e(t)，输出 i(t)

% 传递函数分子分母系数（降幂排列）
num = [1 6 4];     % s^2 + 6s + 4
den = [1 7 10];    % s^2 + 7s + 10

% 建立传递函数模型
sys = tf(num, den);

% 定义时间范围
t = 0:0.01:10;

% 求冲激响应，存入变量 h
h = impulse(sys, t);

% 求阶跃响应，存入变量 g
g = step(sys, t);

% 绘图：纵向两个子图，按子图数加高画布
figure('Position', [100 100 900 700]);   % 350*2 = 700

subplot(2,1,1);
plot(t, h, 'b', 'LineWidth', 2); 
grid on;
xlabel('时间 (s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('冲激响应 h(t)', 'FontSize', 24);
set(gca, 'FontSize', 24);

subplot(2,1,2);
plot(t, g, 'r', 'LineWidth', 2); 
grid on;
xlabel('时间 (s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('阶跃响应 g(t)', 'FontSize', 24);
set(gca, 'FontSize', 24);

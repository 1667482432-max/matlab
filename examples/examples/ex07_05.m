clear;
close all;
clc;


% ex07_05.m  |  例7.5 · 卷积和（conv＋filter 三法）  |  AI 生成，已校验，R2023b
% 定义 x(n) = u(n) - u(n-6)，有限长序列，n = 0 到 5
nx = 0:5;
x = ones(1, 6);          % 在 n=0~5 取值为 1，其余为 0

% 定义 h(n) = 0.8^n * u(n)，理论上无限长，这里截取前 31 项（n=0 到 30）进行计算
Nh = 30;
nh = 0:Nh;
h = 0.8.^nh;             % 已包含 u(n) 的作用

% 计算线性卷积和 y(n) = x(n) * h(n)
y = conv(x, h);

% 确定对应的序号向量 n
n = 0:(length(x) + length(h) - 2);

% 绘制离散序列 y(n)
figure;
stem(n, y, 'LineWidth', 2);
xlabel('n', 'FontSize', 24);
ylabel('y(n)', 'FontSize', 24);
title('y(n) = x(n) * h(n)', 'FontSize', 24);
set(gca, 'FontSize', 24);  % 坐标轴刻度字号
grid on;

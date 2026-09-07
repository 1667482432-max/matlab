clear;
close all;
clc;


% ex12_07.m  |  例12.7 · 相关与卷积的关系（相关定理）  |  AI 生成，已校验，R2023b
% 验证互相关与卷积的关系：xcorr(x,y) 与 conv(x, fliplr(y)) 等价
clear; clc;

% 1. 生成两个等长有限长信号
N = 8;                      % 信号长度
x = randn(1, N);            % 随机信号 x (行向量)
y = randn(1, N);            % 随机信号 y (行向量)

% 2. 计算互相关和卷积
R_xy = xcorr(x, y);                   % 互相关（默认不归一化）
C    = conv(x, fliplr(y));            % 用卷积实现互相关

% 3. 生成滞后向量（从 -N+1 到 N-1）
lag = -(N-1):(N-1);

% 4. 绘制对比图
figure;
plot(lag, R_xy, 'b-', 'LineWidth', 2);   % 互相关：蓝色实线
hold on;
plot(lag, C, 'r--', 'LineWidth', 2);     % 卷积方式：红色虚线
hold off;
xlabel('滞后 (lag)');
ylabel('幅度');
title('互相关 xcorr(x,y) 与 conv(x, fliplr(y)) 对比');
legend('xcorr(x,y)', 'conv(x, fliplr(y))', 'Location', 'best');
grid on;
set(gca, 'FontSize', 24);

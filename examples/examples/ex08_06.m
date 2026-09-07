clear;
close all;
clc;


% ex08_06.m  |  例8.6 · 二阶带通  |  AI 生成，已校验，R2023b
% 二阶离散系统分析
clear; close all; clc;

% 差分方程系数（按照 filter 约定）
% a(1)*y(n) = b(1)*x(n) + b(2)*x(n-1) + ... - a(2)*y(n-1) - a(3)*y(n-2) ...
% 方程：y(n) = x(n-1) + 1.1*y(n-1) - 0.7*y(n-2)
%  => a = [1, -1.1, 0.7],  b = [0, 1]
b = [0, 1];          % 分子系数：z^{-1} 项
a = [1, -1.1, 0.7];  % 分母系数

%% 1. 零极点图
figure;
zplane(b, a);
title('零极点图');
grid on;

%% 2. 单位样值响应
figure;
impz(b, a, 30);  % 绘制前30个样值
title('单位样值响应 h[n]');
xlabel('n'); ylabel('h[n]');
grid on;

%% 3. 幅频特性与相频特性
% 使用 freqz 计算频率响应（返回幅度和相位）
[h, w] = freqz(b, a, 1024);  % 1024 点频率响应，w 为归一化角频率 (0 到 pi)

% 幅频特性 (dB)
figure;
subplot(2,1,1);
plot(w/pi, 20*log10(abs(h)), 'b-', 'LineWidth', 1.5);
xlabel('归一化频率 (\times\pi rad/sample)');
ylabel('幅度 (dB)');
title('幅频特性');
grid on;

% 相频特性 (度)
subplot(2,1,2);
plot(w/pi, angle(h)*180/pi, 'r-', 'LineWidth', 1.5);
xlabel('归一化频率 (\times\pi rad/sample)');
ylabel('相位 (度)');
title('相频特性');
grid on;

clear;
close all;
clc;


% ex11_10.m  |  例11.10 · 鉴频（FM 解调）  |  AI 生成，已校验，R2023b
clc; clear; close all;

%% 参数设置
wc = 100;          % 载波角频率
wm = 5;            % 调制信号角频率
beta = 5;          % 调频指数
dw = beta * wm;    % 最大角频偏 (beta*wm = 25)

%% 时间向量
Fs = 2000;                     % 采样频率 (远大于信号最高频率)
T = 2 * (2*pi/wm);             % 仿真时长：两个调制周期
t = 0:1/Fs:T-1/Fs;             % 时间序列

%% 生成 FM 信号
% s(t) = cos(wc*t + beta*sin(wm*t))
s = cos(wc*t + beta*sin(wm*t));

%% 鉴频：通过解析信号提取瞬时角频率，再恢复基带
z = hilbert(s);                          % 解析信号
phi = unwrap(angle(z));                  % 瞬时相位（解卷绕）
omega = gradient(phi, 1/Fs);             % 瞬时角频率，使用梯度保持长度一致

% 减去载波角频率，并除以最大频偏，得到恢复的基带
recovered_baseband = (omega - wc) / dw;

% 原始基带信号
baseband_original = cos(wm*t);

%% 绘图对比
figure;
plot(t, baseband_original, 'b-', 'LineWidth', 2);   % 原始基带：蓝色实线
hold on;
plot(t, recovered_baseband, 'r--', 'LineWidth', 2); % 恢复基带：红色虚线
hold off;

grid on;
xlabel('时间 (s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('FM 鉴频恢复的基带与原基带对比', 'FontSize', 24);
legend('原始基带 cos(\omega_m t)', '恢复基带', ...
       'Location', 'best', 'FontSize', 24);
set(gca, 'FontSize', 24);

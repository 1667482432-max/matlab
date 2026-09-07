clear;
close all;
clc;


% ex11_02.m  |  例11.2 · 无失真传输：线性相位 vs 全通  |  AI 生成，已校验，R2023b
% 无失真传输与线性相位演示
% 信号：x(t) = sin(2*pi*t) + sin(6*pi*t)

clear; close all;

% ---------- 信号定义 ----------
fs = 1000;               % 采样频率 (Hz)
T = 2;                   % 总时长 (s)
t = (0:1/fs:T).';        % 时间列向量 (s)
x = sin(2*pi*t) + sin(6*pi*t);

% ---------- 系统定义 ----------
% 1. 线性相位系统：纯延时 tau = 0.3 s
tau = 0.3;
sys_lin = tf(1, 1, 'InputDelay', tau);   % H(s)=e^{-s*tau}

% 2. 非线性相位全通系统（幅频恒为1，相位非线性）
% 二阶全通滤波器：H(s) = (s^2 - 2s + 5)/(s^2 + 2s + 5)
sys_nonlin = tf([1 -2 5], [1 2 5]);

% ---------- 系统输出 ----------
y_lin = lsim(sys_lin, x, t);
y_nonlin = lsim(sys_nonlin, x, t);

% ---------- 绘图1：输入与两路输出波形对比 ----------
figure('Position', [100 100 900 500]);
plot(t, x, 'k-', t, y_lin, 'b--', t, y_nonlin, 'r:', 'LineWidth', 2);
grid on;
xlabel('时间 (s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('输入信号与两个系统的输出对比', 'FontSize', 24);
legend('x(t)', 'y_{lin}(t) (线性相位)', 'y_{nonlin}(t) (非线性相位)', ...
       'FontSize', 24, 'Location', 'best');
set(gca, 'FontSize', 24);
xlim([0 2]);

% ---------- 绘图2：相频特性对比（线性频率轴 0~25 rad/s） ----------
w = linspace(0, 25, 500);          % 频率向量 (rad/s)

% 使用 freqresp 取频率响应，再取相位并解卷绕
H_lin = freqresp(sys_lin, w);     % 线性相位系统
H_lin = H_lin(:);
phase_lin = unwrap(angle(H_lin));   % rad

H_nonlin = freqresp(sys_nonlin, w);
H_nonlin = H_nonlin(:);
phase_nonlin = unwrap(angle(H_nonlin)); % rad

% 转换为度
phase_lin_deg = rad2deg(phase_lin);
phase_nonlin_deg = rad2deg(phase_nonlin);

figure('Position', [100 100 900 500]);
plot(w, phase_lin_deg, 'b-', w, phase_nonlin_deg, 'r--', 'LineWidth', 2);
grid on;
xlabel('频率 (rad/s)', 'FontSize', 24);
ylabel('相位 (度)', 'FontSize', 24);
title('系统相频特性对比', 'FontSize', 24);
legend('线性相位系统 (纯延时)', '非线性相位系统 (全通)', ...
       'FontSize', 24, 'Location', 'best');
set(gca, 'FontSize', 24);
xlim([0 25]);

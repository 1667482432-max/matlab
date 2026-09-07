clear;
close all;
clc;


% ex12_03.m  |  例12.3 · PCM 编解码（均匀量化 + 二进制码字）  |  AI 生成，已校验，R2023b
% PCM编码与解码演示：均匀量化、二进制编码与解码
% 输入：一个完整周期的正弦信号，幅度范围[-1, 1]
% 量化：16个电平（4位二进制编码）

clear; clc; close all;

%% 参数设置
A = 1;                  % 正弦信号幅度
f = 1;                  % 频率 (Hz)
T = 1/f;                % 周期
L = 16;                 % 量化电平数（4位编码）
n_bits = 4;             % 编码位数
fs = 1000;              % 采样率
t = linspace(0, T, fs)'; % 时间向量（一个完整周期）

%% 生成原始正弦信号
x_original = A * sin(2 * pi * f * t);

%% 均匀量化
min_val = -A;
max_val = A;
Delta = (max_val - min_val) / L;           % 量化台阶

% 计算每个采样点的量化索引（0 ~ L-1）
q_index = min(floor((x_original - min_val) / Delta), L-1);
q_index(q_index < 0) = 0;                  % 处理可能的边界下溢

% 量化电平（区间中点）
x_quantized = min_val + (q_index + 0.5) * Delta;

%% PCM编码：dec2bin将量化索引转为二进制码字
code_words = dec2bin(q_index, n_bits);     % 每行一个4位二进制码字

%% PCM解码：bin2dec将二进制码字还原为量化索引
q_index_decoded = bin2dec(code_words);     % 解码后的索引

% 重建量化信号
x_reconstructed = min_val + (q_index_decoded + 0.5) * Delta;

%% 计算量化误差
error_quantization = x_reconstructed - x_original;
max_abs_error = max(abs(error_quantization));

%% 计算量化信噪比 SQNR (dB)
P_signal = mean(x_original.^2);
P_noise = mean(error_quantization.^2);
SQNR_dB = 10 * log10(P_signal / P_noise);

%% 打印关键指标
disp(['量化台阶 Delta = ', num2str(Delta)]);
disp(['量化误差最大绝对值 = ', num2str(max_abs_error)]);
disp(['量化信噪比 SQNR = ', num2str(SQNR_dB), ' dB']);

%% 绘图
figure('Position', [100, 100, 900, 700]);

% 子图1：原始信号与量化重建信号
subplot(2, 1, 1);
plot(t, x_original, 'b-', 'LineWidth', 2);      % 原始信号：蓝色实线
hold on;
stairs(t, x_reconstructed, 'r--', 'LineWidth', 2); % 重建信号：红色虚线阶梯
hold off;
xlabel('时间 (s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('原始信号与量化重建信号', 'FontSize', 24);
legend({'原始信号', '量化重建信号'}, 'FontSize', 24, 'Location', 'best');
grid on;
set(gca, 'FontSize', 24);
xlim([0, T]);

% 子图2：量化误差
subplot(2, 1, 2);
plot(t, error_quantization, 'k-', 'LineWidth', 2); % 量化误差：黑色实线
xlabel('时间 (s)', 'FontSize', 24);
ylabel('误差幅度', 'FontSize', 24);
title('量化误差', 'FontSize', 24);
grid on;
set(gca, 'FontSize', 24);
xlim([0, T]);

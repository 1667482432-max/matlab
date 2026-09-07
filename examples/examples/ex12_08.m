clear;
close all;
clc;


% ex12_08.m  |  例12.8 · 匹配滤波测距（chirp 自相关·含噪）  |  AI 生成，已校验，R2023b
% 匹配滤波测距演示
% 构造线性调频发射脉冲，接收信号为三个不同时延/幅度的回波加高斯白噪声
% 通过互相关（xcorr）实现匹配滤波，从相关峰检测回波时延

clear; close all;

%% 参数设置
Fs = 1000;                  % 采样频率 (Hz)
T = 0.1;                    % 脉冲宽度 (s)
f0 = 100;                   % Chirp 起始频率 (Hz)
f1 = 400;                   % Chirp 终止频率 (Hz)
B = f1 - f0;                % 带宽 300 Hz

% 三个回波的时延和幅度
tau = [0.05, 0.20, 0.35];   % 时延 (s)
amp = [1.0,  0.7,  0.5];    % 幅度

SNR_dB = -5;                % 信噪比 (dB)，负值使噪声淹没信号

%% 生成发射 Chirp 脉冲
t_tx = 0:1/Fs:T-1/Fs;                   % 时间向量
tx = chirp(t_tx, f0, T, f1);            % 线性调频信号

%% 构造接收信号（三个回波叠加）
tau_samples = round(tau * Fs);          % 时延对应的样本数
tx_len = length(tx);
rx_len = max(tau_samples) + tx_len + 50; % 接收信号长度，留出余量
t_rx = (0:rx_len-1) / Fs;               % 接收信号时间轴

rx_clean = zeros(1, rx_len);            % 纯净回波叠加
for k = 1:3
    start_idx = tau_samples(k) + 1;
    rx_clean(start_idx : start_idx+tx_len-1) = ...
        rx_clean(start_idx : start_idx+tx_len-1) + amp(k) * tx;
end

% 手动添加高斯白噪声，以达到设定的 SNR
signal_power = sum(rx_clean.^2) / rx_len;          % 纯净接收信号的平均功率
noise_power = signal_power / (10^(SNR_dB/10));     % 噪声功率
noise = sqrt(noise_power) * randn(1, rx_len);      % 高斯白噪声
rx_noisy = rx_clean + noise;                       % 含噪接收信号

%% 匹配滤波：接收信号与发射信号的互相关
[R, lags] = xcorr(rx_noisy, tx);         % 互相关
t_lags = lags / Fs;                      % 时延轴（秒）

%% 从相关输出中提取三个回波的时延估计
% 仅考虑正时延部分
pos_mask = (lags >= 0);
R_pos = R(pos_mask);
lags_pos = lags(pos_mask);

% 找出正时延部分最大的三个峰（假设三个回波产生的峰明显高于旁瓣）
[~, sort_idx] = sort(R_pos, 'descend');
top3_idx = sort_idx(1:3);
estimated_lags = lags_pos(top3_idx);
estimated_delays = estimated_lags / Fs;

% 按时延从小到大排序，方便标注
[estimated_delays, sort_order] = sort(estimated_delays);
peak_values = R_pos(top3_idx(sort_order));

%% 绘图
figure('Position', [100, 100, 900, 350*3]);   % 加高画布，3个子图纵向排列

% 子图1：发射 Chirp 波形
subplot(3,1,1);
plot(t_tx, tx, 'b', 'LineWidth', 2);
xlabel('时间 (s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('发射信号 (Chirp)', 'FontSize', 24);
grid on;
set(gca, 'FontSize', 24);

% 子图2：含噪接收信号波形
subplot(3,1,2);
plot(t_rx, rx_noisy, 'b', 'LineWidth', 2);
xlabel('时间 (s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('含噪接收信号', 'FontSize', 24);
grid on;
set(gca, 'FontSize', 24);

% 子图3：匹配滤波输出（相关函数），并标出三个峰
subplot(3,1,3);
plot(t_lags, R, 'b', 'LineWidth', 2);
hold on;
plot(estimated_delays, peak_values, 'rx', 'MarkerSize', 14, 'LineWidth', 2); % 红叉标注峰值
% 标注时延文本
for k = 1:3
    text(estimated_delays(k), peak_values(k), ...
        sprintf('%.2f s', estimated_delays(k)), ...
        'FontSize', 20, 'Color', 'r', 'VerticalAlignment', 'bottom');
end
hold off;
xlabel('时延 (s)', 'FontSize', 24);
ylabel('相关幅度', 'FontSize', 24);
title('匹配滤波输出', 'FontSize', 24);
grid on;
set(gca, 'FontSize', 24);

% 打印检测到的时延（仅用于观察，不属于调试残留）
disp('匹配滤波检测到的三个回波时延（秒）：');
disp(estimated_delays);

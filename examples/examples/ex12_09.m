clear;
close all;
clc;


% ex12_09.m  |  例12.9 · 匹配滤波数字接收（发送→含噪→误码）  |  AI 生成，已校验，R2023b
% 匹配滤波数字接收演示
% 发送随机二进制比特，每个比特用矩形脉冲表示（1→正脉冲，0→负脉冲）
% 加入高斯白噪声后，用匹配滤波器接收，采样判决并统计误码

%% 参数设置
fs = 1000;                % 采样频率 (Hz)
Rb = 10;                  % 比特率 (bps)
Tb = 1/Rb;                % 比特周期 (s)
N_bit = 20;               % 比特个数
T = N_bit * Tb;           % 总时长
t = 0:1/fs:T-1/fs;        % 时间轴

% 发送脉冲：持续整个比特周期的矩形脉冲
Lp = round(Tb * fs);      % 脉冲长度（采样点数）
pulse = ones(1, Lp);      % 幅度为1的矩形脉冲

% 生成随机发送比特 (0/1)
bits_tx = randi([0, 1], 1, N_bit);

% 构造理想发送信号（无噪）
s_tx = zeros(1, length(t));
for n = 1:N_bit
    idx_start = (n-1)*Lp + 1;
    idx_end = n * Lp;
    if bits_tx(n) == 1
        s_tx(idx_start:idx_end) =  pulse;
    else
        s_tx(idx_start:idx_end) = -pulse;
    end
end

%% 添加高斯白噪声
SNR_dB = 5;                     % 信噪比 (dB)
P_s = mean(s_tx.^2);            % 信号功率
P_n = P_s / (10^(SNR_dB/10));   % 噪声功率
noise = sqrt(P_n) * randn(size(s_tx));
r_tx = s_tx + noise;            % 含噪接收信号

%% 匹配滤波（接收信号与发送脉冲的卷积）
y_mf = conv(r_tx, pulse, 'same');  % 输出与输入等长

% 采样判决：每个比特周期结束时刻采样
sampling_idx = (1:N_bit) * Lp;      % 采样点索引
y_sampled = y_mf(sampling_idx);     % 采样值
bits_dec = y_sampled > 0;           % 正→1，负→0

%% 误码统计
error_pos = find(bits_dec ~= bits_tx);   % 出错比特的位置（索引）
num_errors = length(error_pos);
disp(['误码个数：', num2str(num_errors)]);

%% 绘图
figure('Position', [100, 100, 900, 1050]);  % 3个子图加高

% ------------------ 子图1：发送信号（无噪） ------------------
subplot(3, 1, 1);
plot(t, s_tx, 'b-', 'LineWidth', 2);
xlabel('时间 (s)');
ylabel('幅度');
title('发送信号（无噪）');
grid on;
set(gca, 'FontSize', 24);

% ------------------ 子图2：含噪接收信号 ------------------
subplot(3, 1, 2);
plot(t, r_tx, 'r-', 'LineWidth', 2);
xlabel('时间 (s)');
ylabel('幅度');
title('含噪接收信号');
grid on;
set(gca, 'FontSize', 24);

% ------------------ 子图3：匹配滤波输出与采样判决点 ------------------
subplot(3, 1, 3);
plot(t, y_mf, 'k-', 'LineWidth', 2);
hold on;
% 正确判决的采样点用绿色圆圈
correct_idx = setdiff(1:N_bit, error_pos);
if ~isempty(correct_idx)
    plot(t(sampling_idx(correct_idx)), y_sampled(correct_idx), ...
        'go', 'MarkerSize', 10, 'LineWidth', 2);
end
% 错误判决的采样点用红色叉号，并标注“误”
if ~isempty(error_pos)
    plot(t(sampling_idx(error_pos)), y_sampled(error_pos), ...
        'rx', 'MarkerSize', 12, 'LineWidth', 2);
    for k = 1:length(error_pos)
        idx = error_pos(k);
        text(t(sampling_idx(idx)), y_sampled(idx), ' 误', ...
            'FontSize', 24, 'Color', 'r', 'VerticalAlignment', 'middle');
    end
end
hold off;
xlabel('时间 (s)');
ylabel('幅度');
title('匹配滤波输出与采样判决点');
grid on;
set(gca, 'FontSize', 24);

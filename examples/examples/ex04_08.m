clear;
close all;
clc;


% ex04_08.m  |  例4.8 · 抽样·频谱周期延拓  |  AI 生成，已校验，R2023b
% 矩形抽样的频谱周期延拓观察
% 信号：升余弦脉冲 f(t)=0.5*(1+cos(pi*t)), |t|<1
% 抽样：周期矩形脉冲串，周期0.1，脉宽0.05

% -------- 参数设置 --------
Trg = [-2, 2];               % 时域范围（秒）
N = 4000;                    % 时域采样点数
OMGrg = [-100*pi, 100*pi];   % 角频率范围（足够宽以显示频谱周期复制）
K = 4000;                    % 频域采样点数

% 调用prefourier获得时间向量、角频率向量和傅里叶变换矩阵
[t, omg, FT, ~] = prefourier(Trg, N, OMGrg, K);

% -------- 构造信号 --------
% 升余弦脉冲
f = 0.5 * (1 + cos(pi * t)) .* (abs(t) < 1);

% 周期矩形脉冲串：周期0.1，脉宽0.05
p = double(mod(t, 0.1) < 0.05);

% 抽样信号
fs = f .* p;

% -------- 频谱计算 --------
F_f  = FT * f;   % 原信号频谱
F_fs = FT * fs;  % 抽样信号频谱

% -------- 时域绘图 --------
figure;
plot(t, f, 'b-', 'LineWidth', 2); hold on;
plot(t, fs, 'r--', 'LineWidth', 2); hold off;
xlabel('t (s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('时域信号', 'FontSize', 24);
legend('f(t)', 'f_s(t)', 'FontSize', 24);
grid on;
set(gca, 'FontSize', 24);

% -------- 频域绘图（两个子图纵向排列） --------
freq_Hz = omg / (2*pi);   % 转换为频率 (Hz)

figure('Position', [100, 100, 900, 700]);  % 加高画布以容纳两个子图

subplot(2,1,1);
plot(freq_Hz, abs(F_f), 'b-', 'LineWidth', 2);
xlabel('频率 (Hz)', 'FontSize', 24);
ylabel('|F(f)|', 'FontSize', 24);
title('原始信号幅度谱', 'FontSize', 24);
grid on;
set(gca, 'FontSize', 24);
xlim([freq_Hz(1), freq_Hz(end)]);

subplot(2,1,2);
plot(freq_Hz, abs(F_fs), 'r-', 'LineWidth', 2);
xlabel('频率 (Hz)', 'FontSize', 24);
ylabel('|F_s(f)|', 'FontSize', 24);
title('抽样信号幅度谱', 'FontSize', 24);
grid on;
set(gca, 'FontSize', 24);
xlim([freq_Hz(1), freq_Hz(end)]);

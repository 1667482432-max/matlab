clear;
close all;
clc;


% ex06_07.m  |  例6.7 · 基频与谐波谱  |  AI 生成，已校验，R2023b
% 吉他单音谐波分析：估计基频、傅里叶级数谐波幅度
% 数据：Guitar.MAT 中的 wave2proc，采样率 8000 Hz

clear; clc; close all;

%% 1. 加载信号并去除直流
load('Guitar.MAT', 'wave2proc');
Fs = 8000;                      % 采样率
x = wave2proc(:);               % 确保列向量
x = x - mean(x);                % 去直流，便于周期估计
N = length(x);                  % 信号长度
t_vec = (0:N-1)/Fs;             % 时间轴

% ---------- 基频估计：基于信号周期（时域自相关） ----------
% 计算自相关函数（有偏估计），利用正延迟部分
[r, lags] = xcorr(x, 'biased');
r = r(lags >= 0);
lags = lags(lags >= 0);

% 寻找除零延迟外的第一个显著峰：取 r(2:end) 的最大值位置
[~, peak_idx] = max(r(2:end));
T0_samples = lags(peak_idx + 1);    % 周期间隔（采样点数）
f0 = Fs / T0_samples;               % 基频（Hz）

% ---------- 钢琴音名转换 ----------
% 标准：A4 = 440 Hz (MIDI 69)
semitone = 69 + 12 * log2(f0 / 440);
midi_note = round(semitone);
note_names = {'C','C#','D','D#','E','F','F#','G','G#','A','A#','B'};
octave = floor((midi_note - 12) / 12);         % MIDI 12 = C0
note_idx = mod(midi_note - 12, 12) + 1;
note_str = sprintf('%s%d', note_names{note_idx}, octave);

fprintf('基频 f0 = %.4f Hz\n', f0);
fprintf('钢琴音名: %s\n\n', note_str);

%% 2. 傅里叶级数谐波幅度（使用 prefourier）
H = 10;                            % 分析的谐波最高次数
freqs = (1:H) * f0;                % 各次谐波频率（Hz）

% 设定 prefourier 参数
Trg = [0, (N-1)/Fs];               % 时间范围
OMGrg = [0, 2*pi*freqs(end)];      % 频率范围：只到最高次谐波
K = N;                             % 频率采样点数，与时间点数相同

% 调用已有函数 prefourier（不重新定义）
[t, omg, FT, ~] = prefourier(Trg, N, OMGrg, K);

% 计算信号在 omg 各频率点的傅里叶变换值
Xf = FT * x;                       % Xf(k) 对应 omg(k) 处的连续傅里叶变换近似值

% 提取各次谐波的幅度（取与理想谐波频率最近的频率点）
harmonics_abs = zeros(1, H);
for k = 1:H
    omega_target = 2 * pi * freqs(k);
    [~, idx] = min(abs(omg - omega_target));
    harmonics_abs(k) = abs(Xf(idx));
end

% 基波归一化
harmonics = harmonics_abs / harmonics_abs(1);

% 打印谐波幅度
fprintf('谐波幅度（基波归一化）：\n');
for k = 1:H
    fprintf('  第 %2d 次: %.4f\n', k, harmonics(k));
end

%% 3. 绘制谐波幅度 stem 图
figure('Position', [100 100 900 450]);   % 适当加高画布
stem(1:H, harmonics, 'LineWidth', 2, 'Color', 'b');
xlabel('谐波次数', 'FontSize', 24);
ylabel('归一化幅度', 'FontSize', 24);
title('吉他单音谐波幅度谱', 'FontSize', 24);
grid on;
set(gca, 'FontSize', 24);
% 单曲线不加 legend

% 最终变量 f0 和 harmonics 已存在于工作区

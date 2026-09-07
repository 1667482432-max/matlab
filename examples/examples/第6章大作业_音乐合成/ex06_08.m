clear;
close all;
clc;


% ex06_08.m  |  例6.8 · 真实音色重合成  |  AI 生成，已校验，R2023b
% 完整脚本：吉他单音傅里叶分析 + 基于该音色合成《东方红》旋律
% 分析部分提取基频 f0 和谐波幅度 harmonics；
% 合成部分用相同的谐波结构生成《东方红》开头四小节。
% 兼容 MATLAB R2023b。

%% ================== 第一部分：分析原始吉他音 ==================
% 1. 加载数据
load('Guitar.MAT');                     % 文件应包含 wave2proc
Fs = 8000;
x = wave2proc(:);
L = length(x);

% 2. 自相关法估计基频（时域，不依赖频谱峰值）
[r, lags] = xcorr(x, 'biased');        % 自相关序列（有偏估计）
r_pos = r(lags >= 0);                  % 正滞后部分
lags_pos = lags(lags >= 0);
[~, idx_peak] = max(r_pos(2:end));     % 跳过零滞后，找第一个显著峰
lag = lags_pos(idx_peak + 1);          % 基音对应的滞后（样本数）
f0 = Fs / lag;                         % 基频 Hz

% 3. 转换为钢琴音名（A4=440 Hz，十二平均律）
semitone = 12 * log2(f0 / 440);
n = round(semitone);
notes = {'A','A#','B','C','C#','D','D#','E','F','F#','G','G#'};
idx_note = mod(n, 12) + 1;
octave = 4 + floor((n + 9) / 12);
note_name = sprintf('%s%d', notes{idx_note}, octave);
fprintf('估算基频 f0 = %.2f Hz\n', f0);
fprintf('对应音名：%s\n', note_name);

% 4. 截取一个完整周期的稳态部分
T0 = 1 / f0;
Ns = round(Fs * T0);                   % 一个周期采样点数
start_idx = max(1, L - 2*Ns + 1);      % 取末尾稳定区
if start_idx + Ns - 1 > L
    start_idx = L - Ns + 1;
end
x_cycle = x(start_idx : start_idx + Ns - 1);

% 5. 用 prefourier 在单周期上计算频谱，提取各次谐波幅度
max_harmonic = 15;                     % 最高谐波次数
Trg = [0, Ns/Fs];                      % 时域区间
N = Ns;
f_max = max_harmonic * f0;
OMGrg = 2 * pi * [0, f_max + 0.5*f0]; % 频域区间 (rad/s)
K = 2000;                              % 频域采样点数，保证频率分辨率

[t, omg, FT, ~] = prefourier(Trg, N, OMGrg, K);
X = FT * x_cycle(:);                   % 周期信号的单个周期傅里叶变换

A = zeros(max_harmonic + 1, 1);        % 索引1为直流，2为基波，…
for k = 0 : max_harmonic
    target_omg = 2 * pi * k * f0;
    [~, idx] = min(abs(omg - target_omg));
    if k == 0
        A(1) = abs(X(idx)) / T0;
    else
        A(k+1) = 2 * abs(X(idx)) / T0; % 余弦幅度
    end
end
harmonics = A(2:end) / A(2);           % 基波归一化

fprintf('\n谐波次数及归一化幅度（基波归一）：\n');
for k = 1 : max_harmonic
    fprintf('第 %2d 次谐波：%.4f\n', k, harmonics(k));
end

% 6. 绘制谐波幅度 stem 图
figure('Position', [100, 100, 900, 500]);
stem(1:max_harmonic, harmonics, 'LineWidth', 2, 'Color', [0 0.4470 0.7410]); % 深蓝
grid on;
xlabel('谐波次数', 'FontSize', 24);
ylabel('归一化幅度', 'FontSize', 24);
title('吉他单音谐波幅度（基波归一）', 'FontSize', 24);
set(gca, 'FontSize', 24);

%% ================== 第二部分：合成《东方红》旋律 ==================
% 乐谱设定（1=F，2/4拍，一拍≈0.5秒）
% 简谱序列：5(1拍) 5(半) 6(半) 2(2拍) 1(1拍) 1(半) 低6(半) 2(2拍)
steps = [5 5 6 2 1 1 -6 2];            % 负数表示低八度
durations = [0.5, 0.25, 0.25, 1.0, 0.5, 0.25, 0.25, 1.0]; % 秒

% 将音阶数字转换为频率（F大调：1=F4, 2=G4, 3=A4, 4=Bb4, 5=C5, 6=D5, 7=E5）
% 计算每个音相对A4（440 Hz）的半音差
base_semitone = [ -4, -2, 0, 1, 3, 5, 7 ]; % 对应的半音差（1~7）
freqs = zeros(size(steps));
for i = 1:length(steps)
    step = steps(i);
    if step > 0
        semitone_diff = base_semitone(step);
    else
        abs_step = abs(step);
        semitone_diff = base_semitone(abs_step) - 12; % 低八度
    end
    freqs(i) = 440 * 2^(semitone_diff/12);
end

% 打印合成所用的基频和谐波幅度
fprintf('\n===== 合成《东方红》所用参数 =====\n');
fprintf('谐波次数及归一化幅度（与吉他一致）：\n');
for k = 1 : max_harmonic
    fprintf('  第 %2d 次谐波：%.4f\n', k, harmonics(k));
end
fprintf('旋律音符基频列表：\n');
for i = 1:length(steps)
    if steps(i) > 0
        fprintf('  音符 %d（简谱%d），%.2f Hz，时长 %.2f s\n', i, steps(i), freqs(i), durations(i));
    else
        fprintf('  音符 %d（简谱低%d），%.2f Hz，时长 %.2f s\n', i, abs(steps(i)), freqs(i), durations(i));
    end
end

% 合成每个音符，拼接完整信号
y_guitar = [];                         % 最终信号
attack_slope = round(0.005 * Fs);      % 5 ms 的起音/尾音斜坡，避免阶跳
harmonic_idx = (1:max_harmonic)';      % 谐波次数向量，列向量
for i = 1:length(steps)
    f_note = freqs(i);
    dur = durations(i);
    Ns_note = round(Fs * dur);
    if Ns_note < 1, continue; end
    t_note = (0:Ns_note-1)' / Fs;
    
    % 叠加谐波（余弦，零相位）
    % harmonics 是列向量，harmonic_idx 与其对应
    y_note = cos(2 * pi * f_note * harmonic_idx .* t_note')' * harmonics;   % Ns_note x 1
    
    % 包络：简单的指数衰减，模拟吉他拨弦后的自然衰减
    tau_env = 0.25;                    % 衰减时间常数（秒）
    env = exp(-t_note / tau_env);
    
    % 微小的起音时间（避免初始阶跳）
    if Ns_note > 2*attack_slope
        env(1:attack_slope) = env(1:attack_slope) .* (0:attack_slope-1)' / attack_slope;
    end
    % 末尾微小的淡出斜坡
    if Ns_note > attack_slope
        env(end-attack_slope+1:end) = env(end-attack_slope+1:end) .* (attack_slope-1:-1:0)' / attack_slope;
    end
    
    y_note = y_note .* env;
    
    % 拼接到总信号
    y_guitar = [y_guitar; y_note];
end

% 播放合成音乐
sound(y_guitar, Fs);

% 绘制合成乐曲波形
t_total = (0:length(y_guitar)-1)' / Fs;
figure('Position', [100, 100, 900, 500]);
plot(t_total, y_guitar, 'LineWidth', 2, 'Color', [0 0.4470 0.7410]); % 深蓝
grid on;
xlabel('时间 (秒)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('合成吉他演奏《东方红》波形', 'FontSize', 24);
set(gca, 'FontSize', 24);
xlim([t_total(1), t_total(end)]);

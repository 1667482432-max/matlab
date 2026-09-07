clear;
close all;
clc;


% ex06_04.m  |  例6.4 · 谐波与音色  |  AI 生成，已校验，R2023b
% 《东方红》开头四小节音乐合成 —— 添加谐波
% 1=F，2/4拍，一拍约0.5秒
% 简谱：5(一拍) 5(半) 6(半) 2(两拍) 1(一拍) 1(半) 低6(半) 2(两拍)
% F大调中音音阶 1234567 = F4 G4 A4 ♭B4 C5 D5 E5
% 采样率 8000 Hz，用正弦波合成；叠加二、三次谐波使音色接近风琴

clear; close all; clc;

%% 参数设置
fs = 8000;              % 采样率 (Hz)
beat_duration = 0.5;    % 一拍时长 (秒)
A4 = 440;               % 标准音 A4 频率 (Hz)

% 谐波幅度比（相对于基波幅度1）
A1 = 1.0;               % 基波幅度
A2 = 0.2;               % 二次谐波幅度
A3 = 0.3;               % 三次谐波幅度

%% 按十二平均律计算 F 大调中音音阶各音频率
f_F4  = A4 * 2^(-4/12);   % F4  = 1 (F大调的主音)
f_G4  = A4 * 2^(-2/12);   % G4  = 2
f_A4  = A4 * 2^(0/12);    % A4  = 3
f_Bb4 = A4 * 2^(1/12);    % ♭B4 = 4
f_C5  = A4 * 2^(3/12);    % C5  = 5
f_D5  = A4 * 2^(5/12);    % D5  = 6
f_E5  = A4 * 2^(7/12);    % E5  = 7
f_D4  = f_D5 / 2;         % D4  = 低6 (比D5低一个八度)

%% 根据简谱确定每个音符对应的频率和时值
freqs = [f_C5, f_C5, f_D5, f_G4, f_F4, f_F4, f_D4, f_G4];
durations = [beat_duration, beat_duration/2, beat_duration/2, beat_duration*2, ...
             beat_duration, beat_duration/2, beat_duration/2, beat_duration*2];
total_duration = sum(durations);   % 总时长 4 秒
note_labels = {'5(C5)', '5(C5)', '6(D5)', '2(G4)', '1(F4)', '1(F4)', '低6(D4)', '2(G4)'};

%% 打印各次谐波的幅度比
fprintf('========== 谐波幅度比 ==========\n');
fprintf('基    波 (1×)：幅度 = %.2f\n', A1);
fprintf('二次谐波 (2×)：幅度 = %.2f\n', A2);
fprintf('三次谐波 (3×)：幅度 = %.2f\n', A3);
fprintf('================================\n\n');

%% 生成含谐波的音频信号 y_harm
% 采用每个音符内从零相位开始生成正弦分量，然后整体施加线性淡入淡出包络，
% 避免不同音符拼接处的咔嗒声

N_total = round(fs * total_duration);
y_harm = zeros(N_total, 1);
t = (0:N_total-1)' / fs;              % 全局时间轴

fade_samples = round(0.005 * fs);     % 5ms 对应的采样点数用于包络

idx_start = 1;
for k = 1:length(freqs)
    f0 = freqs(k);                    % 基频
    dur = durations(k);
    N_k = round(fs * dur);
    t_k = (0:N_k-1)' / fs;            % 当前音符的局部时间轴
    
    % 生成基波 + 二次谐波 + 三次谐波（各分量相位均从0开始）
    y_k = A1 * sin(2 * pi * f0 * t_k) + ...
          A2 * sin(2 * pi * f0 * 2 * t_k) + ...
          A3 * sin(2 * pi * f0 * 3 * t_k);
    
    % 施加线性淡入淡出包络
    envelope = ones(N_k, 1);
    if N_k > 2 * fade_samples
        envelope(1:fade_samples) = (0:fade_samples-1)' / fade_samples;
        envelope(end-fade_samples+1:end) = (fade_samples-1:-1:0)' / fade_samples;
    else
        envelope = (0:N_k-1)' / N_k;
        envelope = min(envelope, 1 - envelope);
    end
    y_k = y_k .* envelope;
    
    % 填入全局信号
    idx_end = idx_start + N_k - 1;
    y_harm(idx_start:idx_end) = y_k;
    idx_start = idx_end + 1;
end

%% 播放含谐波的音频
fprintf('正在播放《东方红》（含二、三次谐波）...\n');
sound(y_harm, fs);
pause(total_duration + 0.2);
fprintf('播放完毕。\n\n');

%% 选取第一个音符（C5，0.5秒）进行详细分析
note_idx = 1;                  % 第1个音符
f0_selected = freqs(note_idx); % 基频
dur_selected = durations(note_idx);
N_note = round(fs * dur_selected);

% 从 y_harm 中截取该音符的信号
idx_start_note = 1;            % 第一个音符起始索引为1
y_note = y_harm(idx_start_note : idx_start_note + N_note - 1);
t_note = (0:N_note-1)' / fs;   % 该音符局部时间轴

%% 画该音符开头约 10 毫秒的波形片段
N_fragment = round(0.01 * fs);  % 10ms 对应的采样点数 (80点)
t_fragment_ms = t_note(1:N_fragment) * 1000;  % 单位转换为毫秒
y_fragment = y_note(1:N_fragment);

figure('Position', [100, 100, 900, 500]);
plot(t_fragment_ms, y_fragment, 'b-', 'LineWidth', 2);
xlabel('时间 (ms)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title(sprintf('《东方红》第1音符（%s）开头10ms波形片段', note_labels{note_idx}), 'FontSize', 24);
set(gca, 'FontSize', 24);
grid on;
% 单曲线图，不添加 legend

%% 用 prefourier 求该整个音符的傅里叶级数谱
% prefourier 返回时域向量 t_ft、角频率向量 omg、正变换矩阵 FT、逆变换矩阵 IFT
% 用法：[t_ft, omg, FT, IFT] = prefourier(Trg, Ntime, OMGrg, Kfreq)

Trg = [0, dur_selected];            % 时域范围 [0, T]
Ntime = N_note;                     % 时域采样点数
OMG_max = 2 * pi * 3000;            % 角频率上限（超出3倍频许多，以展示完整谱线）
OMGrg = [-OMG_max, OMG_max];        % 角频率范围
Kfreq = 6000;                       % 频域点数（保证频率分辨率够细）

[t_ft, omg, FT, IFT] = prefourier(Trg, Ntime, OMGrg, Kfreq);

% 计算该音符的频谱（傅里叶级数系数近似）
X = FT * y_note(:);                 % 频谱，长度为 Kfreq
freq_Hz = omg / (2 * pi);           % 角频率转换为 Hz

% 绘制幅度谱，仅显示正频率部分，重点关注0～2000 Hz
pos_idx = freq_Hz >= 0 & freq_Hz <= 2000;
freq_plot = freq_Hz(pos_idx);
X_plot = abs(X(pos_idx));

figure('Position', [100, 100, 900, 500]);
plot(freq_plot, X_plot, 'b-', 'LineWidth', 2);
xlabel('频率 (Hz)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title(sprintf('《东方红》第1音符（%s）完整信号的傅里叶级数谱', note_labels{note_idx}), 'FontSize', 24);
set(gca, 'FontSize', 24);
grid on;
% 标注基波与谐波的谱峰位置（f0, 2f0, 3f0）
hold on;
base_freqs = f0_selected * (1:3);
for f_peak = base_freqs
    [~, idx_peak] = min(abs(freq_plot - f_peak));
    plot(freq_plot(idx_peak), X_plot(idx_peak), 'r^', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
end
% 添加基频和谐波频率标注
text(f0_selected, max(X_plot)*0.9, sprintf('f_0=%.1f Hz', f0_selected), ...
    'FontSize', 18, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
text(2*f0_selected, max(X_plot)*0.7, sprintf('2f_0=%.1f Hz', 2*f0_selected), ...
    'FontSize', 18, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
text(3*f0_selected, max(X_plot)*0.5, sprintf('3f_0=%.1f Hz', 3*f0_selected), ...
    'FontSize', 18, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
hold off;
% 单曲线图（幅度谱线），已用标注区分峰，不添加 legend

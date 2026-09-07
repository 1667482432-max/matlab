clear;
close all;
clc;


% ex06_03.m  |  例6.3 · 音高变换  |  AI 生成，已校验，R2023b
% 《东方红》开头四小节音乐合成（1=F，2/4拍，一拍约0.5秒）
% 按十二平均律计算各音频率，用正弦波合成，播放并绘制旋律音高轮廓
% 然后进行三种音高变换：升八度、降八度、升半音，播放并对比波形

clear; clc; close all;

%% ===== 第一部分：合成原始曲目 =====
fs = 8000;                      % 采样率 8000 Hz
A4 = 440;                       % 基准频率 A4 = 440 Hz

% 各音符时值（秒）：一拍=0.5s，半拍=0.25s，两拍=1.0s
durations = [0.5, 0.25, 0.25, 1.0, 0.5, 0.25, 0.25, 1.0];

% 音符名称（用于标注）
note_names = {'5','5','6','2','1','1','低6','2'};

% 计算各音频率（十二平均律）
% F大调中音音阶：1=F4, 2=G4, 3=A4, 4=bB4, 5=C5, 6=D5, 7=E5
% 低6比中音6(D5)低一个八度，即D4
% 公式 f = A4 * 2^(n/12)，n为该音相对于A4（MIDI编号69）的半音差
F4 = A4 * 2^((65 - 69)/12);     % F4: MIDI 65
G4 = A4 * 2^((67 - 69)/12);     % G4: MIDI 67
C5 = A4 * 2^((72 - 69)/12);     % C5: MIDI 72
D5 = A4 * 2^((74 - 69)/12);     % D5: MIDI 74
D4 = A4 * 2^((62 - 69)/12);     % D4: MIDI 62 (低6)

% 按简谱顺序组成频率数组 freqs
freqs = [C5, C5, D5, G4, F4, F4, D4, G4];

%% 合成音频信号（正弦波，幅度1，相位连续拼接）
y = [];                         % 存储最终信号
t_cum = 0;                      % 累计时间起点，保证相位连续

for i = 1:length(freqs)
    dur = durations(i);
    f = freqs(i);
    
    % 该音符的采样点数（四舍五入，保证时长近似）
    N = round(fs * dur);
    
    % 生成该音符的时间轴，接续前一段末尾，确保相位连续
    t_note = t_cum + (0:N-1)' / fs;
    
    % 正弦波信号
    y_note = sin(2 * pi * f * t_note);
    
    % 拼接到总信号
    y = [y; y_note(:)];
    
    % 更新累计时间（实际长度可能因整数化而微调）
    t_cum = t_cum + N / fs;
end

% 生成与 y 相同长度的时间轴 t
t = (0:length(y)-1)' / fs;

%% 播放原始曲目
sound(y, fs);
pause(length(y)/fs + 0.5);      % 等待播放结束

%% 打印各音符频率
fprintf('《东方红》开头四小节各音符频率（Hz）：\n');
for i = 1:length(freqs)
    fprintf('音符 %2s : %8.2f Hz\n', note_names{i}, freqs(i));
end

%% 绘制旋律音高轮廓（频率随音符序号变化的折线图）
figure('Position', [100, 100, 900, 450]);  
plot(1:length(freqs), freqs, 'o-', 'LineWidth', 2, ...
    'Color', [0 0.4470 0.7410]);          % 深蓝色
grid on;
xlabel('音符序号', 'FontSize', 24);
ylabel('频率 (Hz)', 'FontSize', 24);
title('《东方红》开头四小节旋律音高轮廓', 'FontSize', 24);
set(gca, 'FontSize', 24);

%% ===== 第二部分：音高变换 =====
% 通过改变采样间距（重采样）实现变调，播放时仍采用原抽样率 fs
% 这会导致时长变化，但音高按比例改变，是简单的变调方法

% 计算频率倍数
factor_up   = 2;                % 升一个八度，频率×2
factor_down = 0.5;              % 降一个八度，频率×0.5
factor_half = 2^(1/12);         % 升一个半音，频率×2^(1/12)

% 原始信号总时长 T，总点数 N_orig
T = t(end);
N_orig = length(y);

% ---- 升一个八度：点数减为原来的1/2 ----
N_up = round(N_orig / factor_up);           % 新点数
t_up = linspace(0, T, N_up);                % 新时间节点（均匀分布）
y_up = interp1(t, y, t_up, 'spline');       % 三次样条插值重采样

% ---- 降一个八度：点数增为原来的2倍 ----
N_down = round(N_orig / factor_down);       % factor_down=0.5，即乘以2
t_down = linspace(0, T, N_down);
y_down = interp1(t, y, t_down, 'spline');

% ---- 升一个半音：点数乘以 2^(1/12) ----
N_half = round(N_orig * factor_half);
t_half = linspace(0, T, N_half);
y_half = interp1(t, y, t_half, 'spline');

%% 播放变换后的音频，并适当暂停
sound(y_up, fs);
pause(length(y_up)/fs + 0.5);
sound(y_down, fs);
pause(length(y_down)/fs + 0.5);
sound(y_half, fs);
pause(length(y_half)/fs + 0.5);

%% 打印变换信息
fprintf('\n音高变换后的频率倍数与信号长度：\n');
fprintf('升一个八度：频率倍数 = %.3f, 样点数 = %d\n', factor_up, length(y_up));
fprintf('降一个八度：频率倍数 = %.3f, 样点数 = %d\n', factor_down, length(y_down));
fprintf('升一个半音：频率倍数 = %.4f, 样点数 = %d\n', factor_half, length(y_half));

%% ===== 第三部分：波形对比（前30ms） =====
% 截取第一个音符开头约30毫秒的波形，观察周期疏密随音高的变化
dur_seg = 0.03;                         % 30 ms
N_seg   = round(dur_seg * fs);          % 对应采样点数（以原始 fs 为准）
t_seg   = (0:N_seg-1)' / fs;            % 30ms 时间轴

% 从各信号中截取前 N_seg 个样本
seg_orig = y(1:N_seg);
seg_up   = y_up(1:N_seg);
seg_down = y_down(1:N_seg);
seg_half = y_half(1:N_seg);

% 纵向四子图
figure('Position', [100, 100, 900, 350*4]);  % 按子图数 N=4 加高

subplot(4,1,1);
plot(t_seg, seg_orig, 'b-', 'LineWidth', 2);   % 蓝色实线
grid on;
xlabel('时间 (s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('原曲 (前30ms)', 'FontSize', 24);
set(gca, 'FontSize', 24);
% 单曲线不加图例

subplot(4,1,2);
plot(t_seg, seg_up, 'r-', 'LineWidth', 2);     % 红色实线
grid on;
xlabel('时间 (s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('升一个八度 (频率×2)', 'FontSize', 24);
set(gca, 'FontSize', 24);

subplot(4,1,3);
plot(t_seg, seg_down, 'k-', 'LineWidth', 2);   % 黑色实线
grid on;
xlabel('时间 (s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('降一个八度 (频率×0.5)', 'FontSize', 24);
set(gca, 'FontSize', 24);

subplot(4,1,4);
plot(t_seg, seg_half, 'Color', [0 0.5 0], 'LineWidth', 2);  % 深绿色
grid on;
xlabel('时间 (s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('升一个半音 (频率×2^{1/12})', 'FontSize', 24);
set(gca, 'FontSize', 24);

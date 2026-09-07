clear;
close all;
clc;


% ex06_02_L3.m  |  例6.2 · 消啪声（L3）  |  AI 生成，已校验，R2023b
% 《东方红》开头四小节音乐合成 —— 消除拼接杂声
% 调性：1=F，2/4拍，一拍0.5秒
% 简谱及时值：5(一拍) 5(半) 6(半) 2(两拍) 1(一拍) 1(半) 低6(半) 2(两拍)
% F大调音阶：1=F4, 2=G4, 3=A4, 4=♭B4, 5=C5, 6=D5, 7=E5
% 低6比6低一个八度，即D4
% 目标：消除相邻音符直接拼接产生的“啪”声，使旋律连贯，
%       并将处理前后的波形在衔接处对比显示。

close all; clear; clc;

%% 基础参数设置
Fs = 8000;                % 采样率 (Hz)
beat_duration = 0.5;      % 一拍的时长 (秒)
A4_freq = 440;            % 标准音 A4 频率 (Hz)
A4_midi = 69;             % A4 的 MIDI 音符号码

% 定义每个音符：MIDI音高, 时值(拍)
notes = struct(...
    'midi', [72, 72, 74, 67, 65, 65, 62, 67], ...  % C5,C5,D5,G4,F4,F4,D4,G4
    'beats', [1, 0.5, 0.5, 2, 1, 0.5, 0.5, 2]);     % 拍数

% 按十二平均律计算每个音的实际频率
semitone_diff = notes.midi - A4_midi;
freqs = A4_freq * 2.^(semitone_diff/12);   % 频率数组保存为 freqs

%% 1. 原始拼接（直接相接，无任何处理）———— 作为对照信号 y
%    相邻音符衔接处相位不连续，幅度可能有跳变，产生“啪”声。
y = [];
for k = 1:length(freqs)
    dur = notes.beats(k) * beat_duration;         % 当前音符时长（秒）
    t_note = (0:1/Fs:dur-1/Fs)';                 % 该音符的时间轴
    wave = sin(2*pi * freqs(k) * t_note);        % 幅度为1的正弦波
    y = [y; wave];                                % 直接拼接
end
N = length(y);
t = (0:N-1)' / Fs;                               % 全局时间轴

%% 2. 消除杂声的合成 ———— 结果保存为 y2
%    方法：为每个音符生成相同长度的正弦波，再乘上一个“淡入淡出”包络。
%    包络开头一小段从0线性上升到1，结尾一小段从1线性下降到0，
%    中间部分保持1。这样每个音符的起、止幅度都平滑过渡到0，
%    即使拼接处相位不连续，幅度也是连续的，从而消除“啪”声。
%
%    淡入/淡出长度设置：取约10 ms（80个样本），足够短不影响音头，
%    又足以抑制不连续造成的频谱泄漏。

ramp_len = round(0.01 * Fs);          % 10 ms 对应的样本点数（80）
y2 = [];                               % 初始化处理后的信号
note_boundaries = zeros(length(freqs)+1, 1);  % 记录每个音符在y2中的起始索引（最后一项为总长+1）
note_boundaries(1) = 1;               % 第一个音符起始索引为1

for k = 1:length(freqs)
    dur = notes.beats(k) * beat_duration;      % 当前音符时长（秒）
    nSamples = round(dur * Fs);                % 样本点数（与原始生成保持一致）
    t_note = (0:nSamples-1)' / Fs;             % 该音符的时间向量

    % 生成原始正弦波（幅度1）
    wave = sin(2*pi * freqs(k) * t_note);

    % 构造淡入淡出包络
    env = ones(nSamples, 1);                   % 先全部置1
    if nSamples >= 2*ramp_len                  % 长度足够分开上升和下降段
        % 上升段：0 到 1 线性递增
        env(1:ramp_len) = (0:ramp_len-1)' / ramp_len;
        % 下降段：1 到 0 线性递减
        env(end-ramp_len+1:end) = (ramp_len-1:-1:0)' / ramp_len;
    else
        % 极短音符（本例不会出现）：整体用一个三角形窗，0->1->0
        env = (1:nSamples)' / nSamples;        % 简化处理
        env = min(env, 1 - env + 1/nSamples);  % 使其对称
    end

    wave_env = wave .* env;                    % 加包络后的音符信号
    y2 = [y2; wave_env];                       % 平滑拼接

    % 记录下一个音符的起始索引
    note_boundaries(k+1) = note_boundaries(k) + nSamples;
end

% 全局时间轴与y2匹配（长度应与y相同）
t2 = (0:length(y2)-1)' / Fs;

%% 打印各音符频率
fprintf('各音符频率 (Hz):\n');
labels = {'5','5','6','2','1','1','低6','2'};
for k = 1:length(freqs)
    fprintf('  %s (MIDI %d): %.2f Hz, 时值 %.2f 秒\n', ...
        labels{k}, notes.midi(k), freqs(k), notes.beats(k)*beat_duration);
end

%% 播放处理后的音乐 y2
disp('正在播放消除杂声后的旋律 (y2)...');
sound(y2, Fs);
pause(length(y2)/Fs + 0.5);   % 等待播放完毕

%% 取第一处衔接（第一个5与第二个5之间）进行局部对比
% 衔接点索引：第一个音符结束、第二个音符开始的位置
idx_transition = note_boundaries(2) - 1;   % 第一个音符最后一个样本的索引
idx_next = idx_transition + 1;              % 第二个音符第一个样本的索引

% 提取衔接点前后各约0.02秒（160个样本）用于绘图
span = round(0.02 * Fs);                   % 20 ms 对应的样本数
idx_start = max(1, idx_transition - span);
idx_end   = min(length(y), idx_transition + span + 1);  % 保证不越界

% 截取局部信号
t_local = t(idx_start:idx_end);
y_local  = y(idx_start:idx_end);
y2_local = y2(idx_start:idx_end);

% 计算衔接点在局部图中的相对位置
t_trans = t(idx_transition);   % 衔接点时间

%% 打印衔接处的幅度值
fprintf('\n第一处衔接（5 -> 5）的幅度对比:\n');
fprintf('  原始信号 y: 前一音符末尾幅度 = %.6f,  后一音符开头幅度 = %.6f\n', ...
    y(idx_transition), y(idx_next));
fprintf('  处理后 y2: 前一音符末尾幅度 = %.6f,  后一音符开头幅度 = %.6f\n', ...
    y2(idx_transition), y2(idx_next));

%% 绘制上下对照的局部波形图
figure('Position', [100, 100, 900, 700]);    % 两个子图，加高

subplot(2,1,1);
plot(t_local, y_local, 'b-', 'LineWidth', 2);
hold on;
% 用红色虚线标出衔接点时刻
xline(t_trans, 'r--', 'LineWidth', 2);
grid on;
xlabel('时间 (秒)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('原始拼接（y）—— 衔接处局部', 'FontSize', 24);
set(gca, 'FontSize', 24);
legend('信号', '衔接点', 'FontSize', 20);   % 有两条线，加图例
xlim([t_local(1), t_local(end)]);

subplot(2,1,2);
plot(t_local, y2_local, 'k-', 'LineWidth', 2);
hold on;
xline(t_trans, 'r--', 'LineWidth', 2);
grid on;
xlabel('时间 (秒)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('消除杂声后（y2）—— 衔接处局部', 'FontSize', 24);
set(gca, 'FontSize', 24);
legend('信号', '衔接点', 'FontSize', 20);
xlim([t_local(1), t_local(end)]);

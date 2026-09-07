clear;
close all;
clc;


% ex06_01.m  |  例6.1 · 合成《东方红》  |  AI 生成，已校验，R2023b
clear; close all; clc;

%% 📌 参数设置
fs = 8000;                     % 采样率 (Hz)
beat_dur = 0.5;                % 一拍时长 (秒)，2/4拍，一拍0.5秒

%% 🎵 音符信息
% F大调音阶对应MIDI编号 (A4=69, 440 Hz)
% 1=F4(65), 2=G4(67), 3=A4(69), 4=♭B4(70), 5=C5(72), 6=D5(74), 7=E5(76)
% 低6: D4(62)
note_names = {'5','5','6','2','1','1','低6','2'};   % 简谱音符序列
midi_nums  = [ 72,  72,  74,  67,  65,  65,  62,  67]; % 对应MIDI编号
durs       = beat_dur * [1, 0.5, 0.5, 2, 1, 0.5, 0.5, 2]; % 各音符时长 (秒)

%% 🔢 计算频率 (十二平均律)
freqs = 440 * 2.^((midi_nums - 69) / 12);          % 频率数组

% 打印各音频率
fprintf('各音符频率 (Hz):\n');
for i = 1:length(freqs)
    fprintf('  音符 %d (%s): %.2f Hz\n', i, note_names{i}, freqs(i));
end

%% 🎧 信号合成 —— 正弦波拼接
y = [];
for i = 1:length(freqs)
    % 生成当前音符的时间轴 (从0开始，步长1/fs，不含终点，长度 = 采样点数)
    t_note = (0 : 1/fs : durs(i)-1/fs)';
    % 生成幅度为1的正弦波
    note_signal = sin(2 * pi * freqs(i) * t_note);
    y = [y; note_signal];      % 垂直拼接，保持列向量
end

% 总时间轴
total_samples = length(y);
t = (0 : total_samples-1)' / fs;

%% 🔊 播放合成音乐
sound(y, fs);

%% 📈 绘制旋律音高轮廓（频率随音符序号变化）
figure('Position', [100, 100, 900, 600]);  % 适当画布大小
plot(1:length(freqs), freqs, 'b-o', 'LineWidth', 2);
set(gca, 'FontSize', 24);
xlabel('音符序号', 'FontSize', 24);
ylabel('频率 (Hz)', 'FontSize', 24);
title('《东方红》旋律音高轮廓', 'FontSize', 24);
grid on;
% 仅一条曲线，不加图例，含义由标题和轴标签说明

clear;
close all;
clc;


% ex06_05.m  |  例6.5 · 载入与观察  |  AI 生成，已校验，R2023b
% 清空工作区与图形窗口，避免之前运行残留变量或图像干扰
clear; close all;

% 加载 Guitar.MAT 文件，该文件位于当前工作目录下
% Guitar.MAT 中包含变量 realwave，是一段真实吉他乐音
load('Guitar.MAT', 'realwave');

% 将原始波形信号存入指定变量 wave_raw
wave_raw = realwave;

% 采样率：题目已明确给出为 8000 Hz
fs = 8000;

% ----- 播放乐音 -----
% 使用 sound 函数按照采样率 fs 播放音频信号
sound(wave_raw, fs);

% ----- 计算基本参数 -----
N = length(wave_raw);          % 样点数
duration = N / fs;             % 时长（秒）

% ----- 打印关键信息 -----
fprintf('采样率: %d Hz\n', fs);
fprintf('样点数: %d\n', N);
fprintf('时长: %.3f 秒\n', duration);

% ----- 绘制波形 -----
% 生成时间轴，从 0 到 (N-1)/fs，单位秒
t = (0:N-1) / fs;

% 新建图形窗口，单幅图使用默认窗口大小即可
figure;

% 绘制波形曲线：蓝色实线，线宽 2（满足配色与线宽要求）
plot(t, wave_raw, 'b-', 'LineWidth', 2);

% 添加网格（grid on）
grid on;

% 设置坐标轴刻度字号为 24 pt
set(gca, 'FontSize', 24);

% 添加横纵轴标签，字号 24 pt
xlabel('时间 (秒)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);

% 添加标题，字号 24 pt；单曲线不加图例
title('真实吉他乐音波形', 'FontSize', 24);

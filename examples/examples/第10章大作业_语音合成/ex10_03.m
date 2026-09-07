clear;
close all;
clc;


% ex10_03.m  |  例10.3 · 激励通过声道：合成与试听  |  AI 生成，已校验，R2023b
% 信号与系统 - 语音合成大作业：声道二阶全极点系统试听
% 2023b 兼容版本

clear; clc;

fs = 8000;              % 采样频率 8000 Hz
f0 = 200;               % 基音频率 200 Hz
duration = 1;           % 信号时长 1 秒
N = fs * duration;      % 总采样点数

%% 1. 构造激励 e(n) —— 周期单位冲激串
e = zeros(N, 1);
period_samples = fs / f0;               % 基频周期对应的采样点数 (应为40)
impulse_positions = 1 : period_samples : N;  % 所有冲激位置索引
e(impulse_positions) = 1;

%% 2. 声道全极点滤波得到输出 s(n)
a1 = 1.3789;
a2 = -0.9506;
b = 1;                          % 分子系数
a = [1, -a1, -a2];              % 分母系数：1 - a1*z^{-1} - a2*z^{-2}
s = filter(b, a, e);            % 输出语音 s(n)

% 幅度归一化，防止播放时削波失真（也可直接用 soundsc，内置归一化）
e = e / max(abs(e) + eps);
s = s / max(abs(s) + eps);

%% 3. 试听激励与声道输出
fprintf('播放激励 e(n) (周期冲激串, 基频 200 Hz) ...\n');
sound(e, fs);
pause(duration + 0.5);          % 等待播放结束

fprintf('播放输出 s(n) (经过声道滤波器) ...\n');
sound(s, fs);
pause(duration + 0.5);

fprintf('试听完毕。可以明显听出：激励是尖锐的“嗡嗡”声（丰富的高次谐波），\n');
fprintf('经过声道滤波后变成了具有类似元音共鸣特性的声音，音色更“圆润”。\n');

clear;
close all;
clc;


% ex10_02.m  |  例10.2 · 激励：基音周期间隔的脉冲串  |  AI 生成，已校验，R2023b
% 语音激励信号：周期性单位脉冲串，时变基音周期演示
% 采样频率 8000 Hz，时长 1 秒

clear; clc;

Fs = 8000;          % 采样率 (Hz)
T = 1;              % 时长 (s)
N = Fs * T;         % 总样本数

%% 1. 固定基音频率 200 Hz 的脉冲串
f0_200 = 200;
period_200 = round(Fs / f0_200);          % 基音周期样本数（整数）
x_200 = zeros(1, N);
x_200(1:period_200:end) = 1;             % 在每周期起始位置置 1
disp('播放 200 Hz 脉冲串...');
sound(x_200, Fs);
pause(T + 0.5);                           % 等待播放结束

%% 2. 固定基音频率 300 Hz 的脉冲串
f0_300 = 300;
period_300 = round(Fs / f0_300);          % 8000/300 ≈ 26.67，取整为 27
x_300 = zeros(1, N);
x_300(1:period_300:end) = 1;
disp('播放 300 Hz 脉冲串...');
sound(x_300, Fs);
pause(T + 0.5);

%% 3. 时变基音周期的脉冲串
% 每 10 ms 为一段，共 100 段
seg_len = Fs * 0.01;                      % 10 ms 对应的样本数 = 80
num_seg = N / seg_len;                    % 段数 = 100

x_var = zeros(1, N);

for m = 0:(num_seg - 1)
    % 当前段基音周期（样本数）：PT = 80 + 5 * mod(m, 50)
    PT = 80 + 5 * mod(m, 50);

    % 当前段起止索引（MATLAB 下标从 1 开始）
    start_idx = m * seg_len + 1;
    end_idx   = (m + 1) * seg_len;

    % 在段内按固定间隔 PT 放置单位脉冲
    pulse_pos = start_idx : PT : end_idx;
    x_var(pulse_pos) = 1;
end

disp('播放时变基音周期脉冲串...');
sound(x_var, Fs);

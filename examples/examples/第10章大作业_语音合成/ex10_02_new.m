% 信号与系统语音合成作业 - 浊音激励脉冲串
clear; clc; close all;

Fs = 8000;          % 抽样频率 (Hz)
T = 1;              % 持续时间 (s)
N = Fs * T;         % 总样本数

%% 1. 基音频率 200 Hz (基音周期 = Fs/200 = 40 样本)
f0_200 = 200;
PT_200 = round(Fs / f0_200);   % 40
x200 = zeros(N,1);
pos = 1;
while pos <= N
    x200(pos) = 1;
    pos = pos + PT_200;
end

%% 2. 基音频率 300 Hz (基音周期 = Fs/300 ≈ 26.6667，四舍五入取整)
f0_300 = 300;
PT_300 = round(Fs / f0_300);   % 27
x300 = zeros(N,1);
pos = 1;
while pos <= N
    x300(pos) = 1;
    pos = pos + PT_300;
end

%% 3. 基音周期分段变化
x_var = zeros(N,1);
pos = 1;
while pos <= N
    x_var(pos) = 1;
    m = floor((pos-1) / 80);       % 段号，每段80个样本 (10ms)
    PT = 80 + 5 * mod(m, 50);      % 当前段基音周期 (样本数)
    pos = pos + PT;
end

%% 试听
disp('播放 200 Hz 脉冲串...');
sound(x200, Fs);
pause(T + 0.5);
disp('播放 300 Hz 脉冲串...');
sound(x300, Fs);
pause(T + 0.5);
disp('播放基音周期分段变化脉冲串...');
sound(x_var, Fs);
pause(T + 0.5);

%% 绘图（显示前 25 ms，即 200 个样本，便于观察脉冲间隔）
N_show = 200;   % 显示样本数
t = (0:N_show-1) / Fs * 1000;   % 时间 (毫秒)

figure('Position', [100, 100, 900, 350*3]);

subplot(3,1,1);
stem(t, x200(1:N_show), 'b', 'LineWidth', 2, 'MarkerSize', 4);
grid on;
xlabel('时间 (ms)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('基音频率 200 Hz (周期 40 样本)', 'FontSize', 24);
set(gca, 'FontSize', 24);

subplot(3,1,2);
stem(t, x300(1:N_show), 'r', 'LineWidth', 2, 'MarkerSize', 4);
grid on;
xlabel('时间 (ms)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('基音频率 300 Hz (周期 27 样本)', 'FontSize', 24);
set(gca, 'FontSize', 24);

subplot(3,1,3);
stem(t, x_var(1:N_show), 'k', 'LineWidth', 2, 'MarkerSize', 4);
grid on;
xlabel('时间 (ms)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('基音周期分段变化 (PT = 80+5·mod(m,50) 样本)', 'FontSize', 24);
set(gca, 'FontSize', 24);

set(gcf, 'Color', 'w');
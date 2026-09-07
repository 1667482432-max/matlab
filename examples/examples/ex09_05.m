clear;
close all;
clc;


% ex09_05.m  |  例9.5 · 补零与频率分辨率  |  AI 生成，已校验，R2023b
% 频谱分析：补零能否提高频率分辨率
% 信号：x(t) = cos(2*pi*100*t) + cos(2*pi*150*t)，采样率 fs = 1000 Hz

clear; clc; close all;

fs = 1000;                      % 采样率

% ---------- 情况1：N=16 直接 FFT ----------
N1 = 16;
t1 = (0:N1-1) / fs;            % 时间向量，长度 16 点
x1 = cos(2*pi*100*t1) + cos(2*pi*150*t1);
X1 = fft(x1);                  % N1 点 FFT
f1_full = (0:N1-1) * fs / N1;  % 双边频率轴
idx1 = 1 : N1/2+1;             % 单边谱索引（0 ~ fs/2）
f1 = f1_full(idx1);
mag1 = abs(X1(idx1));

% ---------- 情况2：N=16 补零至 256 点 FFT ----------
Npad = 256;
X2 = fft(x1, Npad);            % 补零到 256 点
f2_full = (0:Npad-1) * fs / Npad;
idx2 = 1 : Npad/2+1;
f2 = f2_full(idx2);
mag2 = abs(X2(idx2));

% ---------- 情况3：N=64 直接 FFT ----------
N3 = 64;
t3 = (0:N3-1) / fs;
x3 = cos(2*pi*100*t3) + cos(2*pi*150*t3);
X3 = fft(x3);
f3_full = (0:N3-1) * fs / N3;
idx3 = 1 : N3/2+1;
f3 = f3_full(idx3);
mag3 = abs(X3(idx3));

% ---------- 绘图 ----------
figure('Position', [100, 100, 900, 1050]);  % 加大高度以容纳三个子图

% 子图1：N=16 直接 FFT
subplot(3,1,1);
plot(f1, mag1, 'b', 'LineWidth', 2);
grid on;
set(gca, 'FontSize', 24);
xlabel('频率 (Hz)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('(1) N=16 直接 FFT', 'FontSize', 24);

% 子图2：N=16 补零至 256 点 FFT
subplot(3,1,2);
plot(f2, mag2, 'r', 'LineWidth', 2);   % 用红色区分
grid on;
set(gca, 'FontSize', 24);
xlabel('频率 (Hz)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('(2) N=16 补零至 256 点 FFT', 'FontSize', 24);

% 子图3：N=64 直接 FFT
subplot(3,1,3);
plot(f3, mag3, 'k', 'LineWidth', 2);   % 用黑色区分
grid on;
set(gca, 'FontSize', 24);
xlabel('频率 (Hz)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('(3) N=64 直接 FFT', 'FontSize', 24);

clear;
close all;
clc;


% ex12_04.m  |  例12.4 · 二进制数字调制（2ASK／2FSK／2PSK）  |  AI 生成，已校验，R2023b
% 二进制数字调制三种基本方式的演示（2ASK,2FSK,2PSK）
% 不使用通信工具箱，完全手写实现

clear; clc; close all;

%% 参数设置
bits = [1 0 1 1 0 1 0 0 1 0];    % 二进制比特流
Tb = 0.1;                         % 比特持续时间 (s)
fs = 1000;                        % 采样率 (Hz)
fc = 10;                          % 2ASK / 2PSK 载波频率 (Hz)
f1 = 6;                           % 2FSK 比特1频率 (Hz)
f2 = 14;                          % 2FSK 比特0频率 (Hz)
A = 1;                            % 载波幅度

%% 时间轴与基带信号
Ns = Tb * fs;                     % 每个比特的采样点数
total_samples = length(bits) * Ns;
t = (0:total_samples-1) / fs;    % 完整时间向量

% 将比特扩展为采样点级别的基带信号 m(t)，0/1
m_t = kron(bits, ones(1, Ns));

%% 调制信号生成
% 1) 2ASK : 比特1发送载波，比特0不发送（幅度为零）
s_ask = A * m_t .* cos(2*pi*fc*t);

% 2) 2FSK : 比特1用频率f1，比特0用频率f2
s_fsk = A * ( (m_t==1).*cos(2*pi*f1*t) + (m_t==0).*cos(2*pi*f2*t) );

% 3) 2PSK : 比特1相位0，比特0相位180度（乘-1）
s_psk = A * (2*m_t - 1) .* cos(2*pi*fc*t);

%% 绘图对比
figure('Position', [100, 100, 900, 350*4]);   % 纵向4子图，画布加高

% 子图1：比特流阶梯波形
subplot(4,1,1);
stairs(t, m_t, 'k', 'LineWidth', 2);          % 黑色阶梯
grid on;
set(gca, 'FontSize', 24);
xlabel('Time (s)', 'FontSize', 24);
ylabel('Amplitude', 'FontSize', 24);
title('Bit Stream', 'FontSize', 24);
ylim([-0.2, 1.2]);

% 子图2：2ASK 已调信号
subplot(4,1,2);
plot(t, s_ask, 'b', 'LineWidth', 2);          % 蓝色实线
grid on;
set(gca, 'FontSize', 24);
xlabel('Time (s)', 'FontSize', 24);
ylabel('Amplitude', 'FontSize', 24);
title('2ASK Modulated Signal', 'FontSize', 24);

% 子图3：2FSK 已调信号
subplot(4,1,3);
plot(t, s_fsk, 'r', 'LineWidth', 2);          % 红色实线
grid on;
set(gca, 'FontSize', 24);
xlabel('Time (s)', 'FontSize', 24);
ylabel('Amplitude', 'FontSize', 24);
title('2FSK Modulated Signal', 'FontSize', 24);

% 子图4：2PSK 已调信号
subplot(4,1,4);
plot(t, s_psk, 'Color', [0 0.5 0], 'LineWidth', 2);  % 深绿色实线
grid on;
set(gca, 'FontSize', 24);
xlabel('Time (s)', 'FontSize', 24);
ylabel('Amplitude', 'FontSize', 24);
title('2PSK Modulated Signal', 'FontSize', 24);

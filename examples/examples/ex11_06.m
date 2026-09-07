clear;
close all;
clc;


% ex11_06.m  |  例11.6 · 常规调幅 AM 与包络检波  |  AI 生成，已校验，R2023b
% 常规调幅（AM）与包络检波演示
% 基带 g(t)=3*cos(10*t)+2*cos(20*t)
% 载波 cos(100*t)
% 已调信号 s(t)=[1+0.8*gn(t)]*cos(100*t)，gn 是 g 归一化到峰值为 1 的基带

clear; close all;

% --- 参数设置 ---
Trg = [0, 2];          % 时域范围
N   = 4096;            % 时域点数
OMGrg = [-200, 200];   % 频域范围 (rad/s)
K   = 4096;            % 频域点数

% 调用 prefourier 生成时间、频率向量和变换矩阵
[t, omg, FT, ~] = prefourier(Trg, N, OMGrg, K);

% 构造基带 g(t)，并归一化
g  = 3*cos(10*t) + 2*cos(20*t);      % 原始基带
gn = g / max(abs(g));                 % 归一化基带，峰值=1

% 已调信号 s(t)
s = (1 + 0.8*gn) .* cos(100*t);

% 频谱 S
S = FT * s;      % 用傅里叶变换矩阵求频谱

% ---------- 图1：已调信号波形（局部）与频谱 ----------
figure('Position', [100, 100, 900, 700]);

subplot(2,1,1);
plot(t, s, 'b', 'LineWidth', 2);
xlim([0 0.3]);              % 截取一小段，能看清载波与包络
xlabel('t', 'FontSize', 24);
ylabel('s(t)', 'FontSize', 24);
title('已调信号波形', 'FontSize', 24);
set(gca, 'FontSize', 24);
grid on;

subplot(2,1,2);
plot(omg, abs(S), 'r', 'LineWidth', 2);
xlabel('频率 (rad/s)', 'FontSize', 24);
ylabel('|S|', 'FontSize', 24);
title('已调信号幅度谱', 'FontSize', 24);
set(gca, 'FontSize', 24);
grid on;

% ---------- 图2：包络检波恢复基带 ----------
% 包络检波：取解析信号的模
envelope = abs(hilbert(s));           % 包络 = 1 + 0.8*gn
gn_hat = (envelope - 1) / 0.8;        % 恢复的归一化基带

figure('Position', [100, 100, 900, 500]);
plot(t, gn, 'b', 'LineWidth', 2); hold on;
plot(t, gn_hat, 'r--', 'LineWidth', 2); hold off;
xlabel('t', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('包络检波恢复基带与原始归一化基带对比', 'FontSize', 24);
legend('归一化基带 gn', '恢复基带', 'FontSize', 24, 'Location', 'northeast');
set(gca, 'FontSize', 24);
grid on;

clear;
close all;
clc;


% ex05_05.m  |  例5.5 · 零极点→频域  |  AI 生成，已校验，R2023b
% 根据零极点绘制8个系统的幅频特性，判断滤波网络类型
clear; close all;
set(0, 'DefaultAxesFontSize', 24);  % 全局统一字号 24pt

% ---- 零极点定义 ----
% 依次为 (a) ~ (h)，结构与顺序不可改动
systems(1).zeros = [];              systems(1).poles = [-2, -1];
systems(2).zeros = 0;               systems(2).poles = [-2, -1];
systems(3).zeros = [0, 0];          systems(3).poles = [-2, -1];
systems(4).zeros = -0.5;            systems(4).poles = [-2, -1];
systems(5).zeros = 0;               systems(5).poles = [-1+1j, -1-1j];
systems(6).zeros = [1.2j, -1.2j];   systems(6).poles = [-1+1j, -1-1j];
systems(7).zeros = [0, 0];          systems(7).poles = [-1+1j, -1-1j];
systems(8).zeros = [1.2j, -1.2j];   systems(8).poles = [1j, -1j];

% 频率范围 (对数坐标)，涵盖典型极点、零点对应的转折频率
w = logspace(-2, 2, 500);   % 0.01 至 100 rad/s

% 画布按子图数加高，避免过扁
figure('Position', [100, 100, 900, 350*8]);

for idx = 1:8
    z = systems(idx).zeros;
    p = systems(idx).poles;

    % 构造系统函数分子、分母系数
    if isempty(z)
        b = 1;               % 无零点时分子为常数 1
    else
        b = poly(z);
    end
    a = poly(p);             % 极点分母多项式

    % 频率响应
    H = freqs(b, a, w);
    mag_dB = 20*log10(abs(H) + eps);   % dB，避免 log(0)

    % 子图绘制
    subplot(4, 2, idx);
    semilogx(w, mag_dB, 'b-', 'LineWidth', 2);
    grid on;
    xlabel('频率 (rad/s)');
    ylabel('幅度 (dB)');
    title(sprintf('(%c)', 'a' + idx - 1));
    ylim([-60, 20]);        % 固定纵轴范围，突出滤波器类型
end

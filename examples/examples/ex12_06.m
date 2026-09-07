clear;
close all;
clc;


% ex12_06.m  |  例12.6 · 白噪声的自相关与功率谱  |  AI 生成，已校验，R2023b
% 高斯白噪声特征验证：自相关函数 & 功率谱密度
N = 2000;                      % 噪声样本数
x = randn(N, 1);               % 生成均值为0、方差为1的高斯白噪声

% 自相关函数
[r, lags] = xcorr(x, 'biased');  % 有偏估计，便于观察冲击特性

% 功率谱密度（单边，pwelch 默认）
[p, f] = pwelch(x, [], [], [], 1);

% 绘图
figure('Position', [100, 100, 900, 700]);  % 两子图加高
subplot(2, 1, 1);
plot(lags, r, 'b-', 'LineWidth', 2);
title('自相关函数', 'FontSize', 24);
xlabel('滞后', 'FontSize', 24);
ylabel('自相关 R(\tau)', 'FontSize', 24);
grid on; set(gca, 'FontSize', 24);

subplot(2, 1, 2);
plot(f, p, 'r-', 'LineWidth', 2);
title('功率谱密度', 'FontSize', 24);
xlabel('频率 (Hz)', 'FontSize', 24);
ylabel('PSD', 'FontSize', 24);
grid on; set(gca, 'FontSize', 24);

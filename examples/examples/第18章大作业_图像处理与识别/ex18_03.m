clear;
close all;
clc;


% ex18_03.m  |  例18.3 · 一阶信息熵（无损压缩下界）  |  AI 生成，已校验，R2023b
% 读入 MATLAB 自带的灰度演示图像
I = imread('cameraman.tif');  % 256×256 uint8 灰度图

% 计算 0–255 各个灰度级的出现频率作为概率分布 p
edges = 0:256;                % 256 个直方图 bin 的边界
counts = histcounts(I(:), edges);  % 各 bin 计数
p = counts / numel(I);        % 归一化得到概率分布（长度 256）

% 按香农一阶熵公式计算熵 H（bit/像素）
p_pos = p(p > 0);            % 忽略概率为 0 的灰度级，避免 log2(0)
H = -sum(p_pos .* log2(p_pos));

% 等概率分布的理论上界
H_max = log2(256);           % 即 8 bit/像素

% 在命令窗口显示结果
disp(['熵 H = ', num2str(H), ' bit/像素']);
disp(['等概率分布上界 log2(256) = ', num2str(H_max), ' bit/像素']);

% 绘制灰度直方图（概率分布）
figure;
bar(0:255, p, 'FaceColor', [0 0 1], 'EdgeColor', 'none', 'BarWidth', 1);
grid on;
xlabel('灰度级', 'FontSize', 24);
ylabel('概率', 'FontSize', 24);
title(['灰度直方图  (熵 = ', num2str(H, '%.2f'), ' bit/像素)'], 'FontSize', 24);
set(gca, 'FontSize', 24);

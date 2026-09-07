clear;
close all;
clc;


% ex17_02.m  |  例17.2 · 图像频谱：fft2 与频率分量  |  AI 生成，已校验，R2023b
% 二维频谱分析演示：cameraman 与正弦光栅
close all; clear; clc;

%% 1. 读入内置灰度图 cameraman.tif
I = imread('cameraman.tif');
I = double(I);                     % 转为 double 便于傅里叶变换

% 计算二维傅里叶变换，并将零频移到中心
F1 = fft2(I);
F1_shifted = fftshift(F1);
mag1 = log(1 + abs(F1_shifted));   % log 压缩动态范围

%% 2. 生成二维正弦光栅图（256×256，单一空间频率）
N = 256;
x = 0:N-1;
freq = 8;                          % 空间频率：8 个周期/图像宽度
grating = cos(2 * pi * freq * x / N);  % 按列坐标变化的一维信号
grating = repmat(grating, N, 1);   % 扩展为 256×256 图像（垂直条纹）

% 计算光栅图的频谱
F2 = fft2(grating);
F2_shifted = fftshift(F2);
mag2 = log(1 + abs(F2_shifted));

%% 3. 使用 tiledlayout 进行 2×2 对比显示
figure('Name', '二维频谱分析演示', 'NumberTitle', 'off');
tiledlayout(2, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% (a) cameraman 原图
nexttile;
imshow(I, []);
title('Cameraman 原图');
colormap(gca, 'gray');             % 灰度显示
colorbar;

% (b) cameraman 的对数幅度谱
nexttile;
imshow(mag1, []);
title('Cameraman 对数幅度谱');
colormap(gca, 'jet');              % 彩色显示便于观察细节
colorbar;

% (c) 正弦光栅图
nexttile;
imshow(grating, []);
title('正弦光栅 (垂直条纹, f=8)');
colormap(gca, 'gray');
colorbar;

% (d) 光栅图的对数幅度谱
nexttile;
imshow(mag2, []);
title('光栅对数幅度谱 (一对对称亮点)');
colormap(gca, 'jet');
colorbar;

% 额外标记：在光栅频谱图上标注亮点位置（中心在 N/2+1 = 129）
hold on;
center = N/2 + 1;
plot(center + freq, center, 'wo', 'MarkerSize', 10, 'LineWidth', 1.5);
plot(center - freq, center, 'wo', 'MarkerSize', 10, 'LineWidth', 1.5);
hold off;

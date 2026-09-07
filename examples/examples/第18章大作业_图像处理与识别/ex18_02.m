clear;
close all;
clc;


% ex18_02.m  |  例18.2 · 彩色通道分离与灰度化  |  AI 生成，已校验，R2023b
% 读入 MATLAB 自带的彩色演示图像
I = imread('peppers.png');

% 提取红、绿、蓝三个通道
R = I(:, :, 1);
G = I(:, :, 2);
B = I(:, :, 3);

% 转换为灰度图
gray = rgb2gray(I);

% 排版显示：原图 + 三通道灰度 + 灰度图
figure('Position', [100, 100, 900, 350*2]);   % 按纵向2行适当加高画布

subplot(2, 3, 1);
imshow(I);
title('原图', 'FontSize', 24);
set(gca, 'FontSize', 24);   % 统一字号

subplot(2, 3, 2);
imshow(R);
title('R 通道', 'FontSize', 24);
set(gca, 'FontSize', 24);

subplot(2, 3, 3);
imshow(G);
title('G 通道', 'FontSize', 24);
set(gca, 'FontSize', 24);

subplot(2, 3, 4);
imshow(B);
title('B 通道', 'FontSize', 24);
set(gca, 'FontSize', 24);

subplot(2, 3, 5);
imshow(gray);
title('灰度图', 'FontSize', 24);
set(gca, 'FontSize', 24);

% 最后一个子图留空，保持版面整洁
subplot(2, 3, 6);
axis off;

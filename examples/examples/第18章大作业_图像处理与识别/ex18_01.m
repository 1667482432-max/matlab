clear;
close all;
clc;


% ex18_01.m  |  例18.1 · 幅度量化（灰度级离散化）  |  AI 生成，已校验，R2023b
% 读取灰度演示图像并量化为4个等间隔灰度级，与原图并排显示
I = imread('cameraman.tif');            % MATLAB 自带的灰度图像
level = 4;                              % 量化级数
step = 256 / level;                     % 等间隔步长
Iq = uint8(floor(double(I) / step) * step + step / 2);  % 量化到区间中心灰度

% 并排显示原图与量化结果
figure;
subplot(1,2,1);
imshow(I, []);
title('原始图像', 'FontSize', 24);

subplot(1,2,2);
imshow(Iq, []);
title('4级量化图像', 'FontSize', 24);

clear;
close all;
clc;


% ex17_01.m  |  例17.1 · 图像即矩阵：灰度子块与 RGB 通道  |  AI 生成，已校验，R2023b
% 图像基础操作示例：读取 peppers.png，灰度化，取子块，显示各通道并排版对比

% ① 读入内置彩色图像
rgb = imread('peppers.png');

% ② 转换为灰度图像
gray = rgb2gray(rgb);

% ③ 取灰度图左上角 8×8 子块，并打印像素值矩阵
subBlock = gray(1:8, 1:8);
disp('灰度图左上角 8×8 子块像素值矩阵：');
disp(subBlock);

% ④ 提取 R、G、B 三个颜色通道
R = rgb(:, :, 1);  % 红色通道
G = rgb(:, :, 2);  % 绿色通道
B = rgb(:, :, 3);  % 蓝色通道

% ⑤ 使用 tiledlayout 将原图、灰度图、R、G、B 通道排成一版对照
figure('Name', '图像基础操作对比');
tiledlayout(2, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

% 第1个子图：原图
nexttile;
imshow(rgb);
title('原图 (RGB)');

% 第2个子图：灰度图
nexttile;
imshow(gray);
title('灰度图');

% 第3个子图：R 通道
nexttile;
imshow(R);
title('R 通道 (红色分量)');

% 第4个子图：G 通道
nexttile;
imshow(G);
title('G 通道 (绿色分量)');

% 第5个子图：B 通道
nexttile;
imshow(B);
title('B 通道 (蓝色分量)');

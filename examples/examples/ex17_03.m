clear;
close all;
clc;


% ex17_03.m  |  例17.3 · 频域/空域滤波与卷积定理  |  AI 生成，已校验，R2023b
%% 频域滤波与二维卷积定理演示
% 卷积定理：空域卷积等价于频域相乘
% 读入 cameraman.tif 并转为 double

clear; close all; clc;

%% 1. 读取图像并预处理
I = imread('cameraman.tif');          % 读取内置灰度图
I = im2double(I);                     % 转为 double 范围 [0,1]
[M, N] = size(I);                     % 图像尺寸，通常为 256×256

%% 2. 频域低通滤波（模糊）
% 2.1 生成中心圆形掩模，半径约 30 像素
radius = 30;
[X, Y] = meshgrid(1:N, 1:M);         % 坐标网格
cx = N/2 + 1;  cy = M/2 + 1;         % 频谱中心（fftshift 后的原点）
mask_low = ( (X - cx).^2 + (Y - cy).^2 <= radius^2 );  % 圆形低通掩模

% 2.2 频域滤波
F = fft2(I);                          % 二维傅里叶变换
F_shifted = fftshift(F);              % 将零频移到中心
F_low = F_shifted .* mask_low;        % 频域相乘（应用低通掩模）
F_low_shifted = ifftshift(F_low);     % 逆向搬移
I_freq_low = real(ifft2(F_low_shifted)); % 逆傅里叶变换并取实部

%% 3. 空域高斯模糊（与频域低通对照）
% 高斯核标准差取值，产生与 radius=30 类似的模糊效果
sigma = 4;                               % 可调节以获得相近模糊度
hsize = 2 * ceil(3 * sigma) + 1;         % 核大小
h_gauss = fspecial('gaussian', hsize, sigma);
I_spatial_gauss = imfilter(I, h_gauss, 'same', 'replicate');

%% 4. 频域高通滤波（边缘提取）
% 用 1 减去低通掩模得到高通掩模（挖掉低频）
mask_high = 1 - mask_low;                       % 高通掩模
F_high = F_shifted .* mask_high;                % 频域相乘
F_high_shifted = ifftshift(F_high);
I_freq_high = real(ifft2(F_high_shifted));      % 逆变换得到边缘图

%% 5. 空域拉普拉斯滤波（与频域高通对照）
h_laplacian = fspecial('laplacian', 0.2);       % 拉普拉斯核，alpha=0.2
I_spatial_laplacian = imfilter(I, h_laplacian, 'same', 'replicate');

%% 6. 图像显示（tiledlayout 排版）
figure('Name', '频域滤波与空域卷积对照', 'NumberTitle', 'off');
t = tiledlayout(2, 3, 'TileSpacing', 'compact', 'Padding', 'compact');

% 原图
nexttile(1);
imshow(I, []);
title('原图');

% 频域低通模糊
nexttile(2);
imshow(I_freq_low, []);
title('频域低通模糊 (半径=30)');

% 空域高斯模糊
nexttile(3);
imshow(I_spatial_gauss, []);
title('空域高斯模糊 (\sigma=4)');

% 频域高通边缘
nexttile(4);
imshow(I_freq_high, []);
title('频域高通边缘');

% 空域拉普拉斯边缘
nexttile(5);
imshow(I_spatial_laplacian, []);
title('空域拉普拉斯边缘');

% 第6格留空，或可添加说明文字
nexttile(6);
axis off;
text(0.1, 0.5, '卷积定理演示：\newline空域卷积 \Leftrightarrow 频域相乘', ...
    'FontSize', 12, 'Interpreter', 'tex');

sgtitle('频域滤波与空域卷积对照 —— 二维卷积定理演示');

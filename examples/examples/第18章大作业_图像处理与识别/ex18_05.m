clear;
close all;
clc;


% ex18_05.m  |  例18.5 · 解码重建与 PSNR  |  AI 生成，已校验，R2023b
% JPEG 编解码与 PSNR 对比 (标准量化表 vs 放大 4 倍)
clear; close all;

% ---------- 1. 读取图像并预处理 ----------
I = double(imread('cameraman.tif'));      % 灰度图, 大小为 256x256
[M, N] = size(I);
% 保证尺寸为 8 的整数倍（若不满则裁剪）
M8 = floor(M/8)*8;
N8 = floor(N/8)*8;
I = I(1:M8, 1:N8);
[M, N] = size(I);

% ---------- 2. 标准 JPEG 亮度量化表 ----------
Q_std = [16  11  10  16  24  40  51  61;
         12  12  14  19  26  58  60  55;
         14  13  16  24  40  57  69  56;
         14  17  22  29  51  87  80  62;
         18  22  37  56  68 109 103  77;
         24  35  55  64  81 104 113  92;
         49  64  78  87 103 121 120 101;
         72  92  95  98 112 100 103  99];

% 量化表放大 4 倍
Q_4 = Q_std * 4;

% ---------- 3. 编解码与 PSNR 计算 ----------
% 标准量化表
[R, PSNR] = jpeg_codec(I, Q_std);
% 放大 4 倍量化表
[R4, PSNR4] = jpeg_codec(I, Q_4);

% ---------- 4. 显示 PSNR ----------
disp(['标准量化表 PSNR  = ', num2str(PSNR, '%.2f'), ' dB']);
disp(['4倍量化表 PSNR4  = ', num2str(PSNR4, '%.2f'), ' dB']);

% ---------- 5. 结果可视化 ----------
figure('Position', [100 100 1300 420]);   % 横向排列三个图像

% 原始图像
subplot(1,3,1);
imshow(I, [0 255]);  title('原始图像', 'FontSize', 24);
set(gca, 'FontSize', 24);

% 标准量化重建图 R
subplot(1,3,2);
imshow(R, [0 255]);  title(['R (标准), PSNR = ', num2str(PSNR,'%.2f'), ' dB'], 'FontSize', 24);
set(gca, 'FontSize', 24);

% 放大 4 倍量化表重建图
subplot(1,3,3);
imshow(R4, [0 255]); title(['4\times量化表, PSNR = ', num2str(PSNR4,'%.2f'), ' dB'], 'FontSize', 24);
set(gca, 'FontSize', 24);

% ---------- 局部函数：JPEG 编解码 ----------
function [R, psnrVal] = jpeg_codec(img, Q)
    % img: 输入原始图像 (double, 0~255)
    % Q:   8x8 量化表
    % R:   重建图像 (double, 0~255)
    % psnrVal: PSNR (dB)

    [M, N] = size(img);
    % 减去 128 电平偏移
    img_shift = img - 128;
    R = zeros(M, N);

    % 分块处理
    for i = 1:8:M
        for j = 1:8:N
            block = img_shift(i:i+7, j:j+7);
            % 正向 DCT
            DCT_block = dct2(block);
            % 量化
            Q_block = round(DCT_block ./ Q);
            % 反量化
            DCT_rec = Q_block .* Q;
            % 反向 DCT
            rec_block = idct2(DCT_rec);
            % 加回 128 并限制范围
            R(i:i+7, j:j+7) = max(0, min(255, rec_block + 128));
        end
    end

    % 计算 PSNR
    MSE = mean((R(:) - img(:)).^2);
    if MSE == 0
        psnrVal = Inf;
    else
        psnrVal = 10 * log10(255^2 / MSE);
    end
end

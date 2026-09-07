clear;
close all;
clc;


% ex18_06.m  |  例18.6 · 空域 LSB 隐写  |  AI 生成，已校验，R2023b
% LSB 隐写演示
% 使用 MATLAB 自带灰度图像 cameraman.tif
rng(0);                     % 固定随机种子，确保比特序列可复现

% 读入原图（uint8 灰度）
I = imread('cameraman.tif');
[H, W] = size(I);
N = H * W;                  % 总像素数

% 生成随机秘密比特（0/1），长度等于图像像素总数
bits = randi([0, 1], N, 1);
bits_2D = reshape(bits, H, W);   % 重塑为与图像相同尺寸，便于逐像素替换

% LSB 隐写：清除每个像素最低有效位，再写入秘密比特
stego = I - mod(I, 2) + uint8(bits_2D);

% 提取最低有效位，恢复秘密比特
extracted_2D = mod(stego, 2);
extracted = extracted_2D(:);     % 转为一维列向量，与 bits 保持一致

% 验证提取是否正确
if isequal(bits, extracted)
    disp('秘密比特提取正确。');
else
    disp('提取失败，存在不一致的比特。');
end

% 并排显示原图与含密图
figure;
subplot(1,2,1);
imshow(I);
title('原图', 'FontSize', 24);
set(gca, 'FontSize', 24);
grid on;

subplot(1,2,2);
imshow(stego);
title('含密图', 'FontSize', 24);
set(gca, 'FontSize', 24);
grid on;

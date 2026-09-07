clear;
close all;
clc;


% ex18_07.m  |  例18.7 · DCT 域中频系数 ±Δ 隐藏  |  AI 生成，已校验，R2023b
% DCT域信息隐藏与抗压缩验证
% 读入一幅MATLAB自带的灰度演示图像，在8×8分块的DCT中频系数嵌入秘密比特，
% 然后直接提取；再对含密图做均匀量化后提取，验证抗压缩能力。

clear; clc; close all;

%% 1. 读入图像并构造秘密比特
I = imread('cameraman.tif');             % 灰度演示图像（256×256）
I = double(I);                           % 转为双精度便于处理
[rows, cols] = size(I);

% 按8×8分块，计算总块数
blkSize = 8;
numBlkR = floor(rows / blkSize);
numBlkC = floor(cols / blkSize);
totalBlk = numBlkR * numBlkC;

% 生成等长的随机秘密比特（每块嵌入1比特）
rng(0);                                  % 固定随机种子，便于结果复现
bits = randi([0, 1], totalBlk, 1);

%% 2. 嵌入：对每个8×8块进行二维DCT，在中频系数位置嵌入信息
Delta = 30;                              % 嵌入强度（明显大于量化步长）
posR = 5;  posC = 4;                    % 选定的中频系数位置（行5列4，避免直流与极高频）

stego = I;                               % 初始化含密图

idx = 0;                                 % 比特序号
for r = 1:blkSize:numBlkR*blkSize
    for c = 1:blkSize:numBlkC*blkSize
        idx = idx + 1;
        block = I(r:r+blkSize-1, c:c+blkSize-1);
        dctBlock = dct2(block);
        
        % 嵌入1比特：1 -> +Delta, 0 -> -Delta
        if bits(idx) == 1
            dctBlock(posR, posC) = Delta;
        else
            dctBlock(posR, posC) = -Delta;
        end
        
        % 逆DCT并放回
        stego(r:r+blkSize-1, c:c+blkSize-1) = idct2(dctBlock);
    end
end

% 将含密图像素值限制在[0,255]内，并转换为uint8（实际显示/保存用）
stego = max(0, min(255, stego));
stego_uint8 = uint8(stego);              % 可用于显示

%% 3. 直接提取：对含密图重新分块做DCT，根据中频系数符号提取比特
extracted = zeros(totalBlk, 1);
idx = 0;
for r = 1:blkSize:numBlkR*blkSize
    for c = 1:blkSize:numBlkC*blkSize
        idx = idx + 1;
        block = stego(r:r+blkSize-1, c:c+blkSize-1);
        dctBlock = dct2(block);
        
        % 符号为正判1，否则判0
        if dctBlock(posR, posC) > 0
            extracted(idx) = 1;
        else
            extracted(idx) = 0;
        end
    end
end

%% 4. 均匀量化（模拟压缩）并提取
Qstep = 8;                               % 量化步长（小于Delta，但仍有一定影响）
stego_q = round(stego / Qstep) * Qstep;  % 均匀量化
stego_q = max(0, min(255, stego_q));     % 裁剪到有效范围

% 从量化后的图像重新提取
extracted2 = zeros(totalBlk, 1);
idx = 0;
for r = 1:blkSize:numBlkR*blkSize
    for c = 1:blkSize:numBlkC*blkSize
        idx = idx + 1;
        block = stego_q(r:r+blkSize-1, c:c+blkSize-1);
        dctBlock = dct2(block);
        
        if dctBlock(posR, posC) > 0
            extracted2(idx) = 1;
        else
            extracted2(idx) = 0;
        end
    end
end

%% 5. 结果展示（仅统计与显示，不使用图形）
% 直接提取正确率
err1 = nnz(extracted ~= bits);
fprintf('直接提取错误比特数: %d / %d  (误码率: %.2f%%)\n', ...
    err1, totalBlk, err1/totalBlk*100);

% 量化后提取正确率
err2 = nnz(extracted2 ~= bits);
fprintf('Qstep=%d 量化后提取错误比特数: %d / %d  (误码率: %.2f%%)\n', ...
    Qstep, err2, totalBlk, err2/totalBlk*100);

% 显示原图与含密图（遵循绘图规范）
figure('Position', [100, 100, 900, 700]);
subplot(1,2,1);
imshow(uint8(I)); title('原图 I', 'FontSize', 24);
subplot(1,2,2);
imshow(stego_uint8); title('含密图 stego', 'FontSize', 24);

clear;
close all;
clc;


% ex18_08.m  |  例18.8 · 肤色 YCbCr 直方图特征与 L1 距离判别  |  AI 生成，已校验，R2023b
% 肤色标准特征提取与距离测试
% 训练图像: 1.bmp ~ 33.bmp
% 输出: feat (归一化颜色分布), d_skin (肤色块距离), d_nonskin (非肤色块距离)

L = 8;                     % 二维直方图每维量化等级
numTrain = 33;
H_acc = zeros(L, L);       % 累计直方图

% 1. 累加训练图像的 Cb-Cr 二维直方图
for i = 1:numTrain
    img = imread([num2str(i), '.bmp']);
    ycbcr = rgb2ycbcr(img);
    Cb = ycbcr(:,:,2);
    Cr = ycbcr(:,:,3);
    % 将 0~255 量化到 1~L 的 bin 索引
    cbIdx = floor(double(Cb) / 32) + 1;
    crIdx = floor(double(Cr) / 32) + 1;
    cbIdx = min(max(cbIdx, 1), L);
    crIdx = min(max(crIdx, 1), L);
    % 使用 accumarray 统计二维直方图
    H = accumarray([cbIdx(:), crIdx(:)], 1, [L, L]);
    H_acc = H_acc + H;
end

% 2. 归一化得到标准特征 feat (总和为 1)
feat = H_acc / sum(H_acc(:));

% 3. 计算某块图像到标准特征的 L1 距离（各格差绝对值之和）
%    测试块需同样转为归一化直方图

% --- 测试肤色块 (5.bmp) ---
img5 = imread('5.bmp');
ycbcr5 = rgb2ycbcr(img5);
Cb5 = ycbcr5(:,:,2);
Cr5 = ycbcr5(:,:,3);
cbIdx5 = floor(double(Cb5) / 32) + 1;
crIdx5 = floor(double(Cr5) / 32) + 1;
cbIdx5 = min(max(cbIdx5, 1), L);
crIdx5 = min(max(crIdx5, 1), L);
H5 = accumarray([cbIdx5(:), crIdx5(:)], 1, [L, L]);
H5_norm = H5 / sum(H5(:));
d_skin = sum(abs(H5_norm(:) - feat(:)));

% --- 测试非肤色块 (纯绿色块 100x100) ---
greenImg = uint8(zeros(100, 100, 3));
greenImg(:,:,2) = 255;      % 纯绿色 RGB = (0,255,0)
ycbcrGreen = rgb2ycbcr(greenImg);
CbG = ycbcrGreen(:,:,2);
CrG = ycbcrGreen(:,:,3);
cbIdxG = floor(double(CbG) / 32) + 1;
crIdxG = floor(double(CrG) / 32) + 1;
cbIdxG = min(max(cbIdxG, 1), L);
crIdxG = min(max(crIdxG, 1), L);
HG = accumarray([cbIdxG(:), crIdxG(:)], 1, [L, L]);
HG_norm = HG / sum(HG(:));
d_nonskin = sum(abs(HG_norm(:) - feat(:)));

% 显示距离，便于比较
disp(['肤色块 5.bmp 到标准特征的 L1 距离: ', num2str(d_skin)]);
disp(['非肤色纯绿块到标准特征的 L1 距离:    ', num2str(d_nonskin)]);

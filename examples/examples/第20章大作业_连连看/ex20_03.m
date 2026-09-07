clear;
close all;
clc;


% ex20_03.m  |  例20.3 · 傅里叶图像分块（定块宽＋相位定偏移）  |  AI 生成，已校验，R2023b
% --- 1. 读取图像并转为灰度 ---
img = imread('graygroundtruth.jpg');
if ndims(img) == 3
    img = rgb2gray(img);
end
img = double(img);
[H, W] = size(img);

% --- 2. 计算行列平均灰度曲线 ---
col_means = mean(img, 1);   % 1×W，水平方向平均灰度
row_means = mean(img, 2);   % H×1，垂直方向平均灰度

% --- 3. 傅里叶分析水平方向 ---
F_col = fft(col_means);
N_col = length(col_means);
amp_col = abs(F_col);
phase_col = angle(F_col);

% 只考虑正频率部分（2 : floor(N_col/2)+1），去掉直流
half_col = floor(N_col/2) + 1;
amp_col_pos = amp_col(2:half_col);
phase_col_pos = phase_col(2:half_col);
freq_col = (1:length(amp_col_pos))';   % 频率索引 k

% 计算对应周期
periods_col = N_col ./ freq_col;

% 限制最小周期为 30 像素
valid_idx_col = periods_col >= 30;
amp_col_valid = amp_col_pos(valid_idx_col);
periods_col_valid = periods_col(valid_idx_col);
phase_col_valid = phase_col_pos(valid_idx_col);
freq_col_valid = freq_col(valid_idx_col);

% 寻找幅度主峰（避免高频纹理干扰）
[~, max_idx_col] = max(amp_col_valid);
T_col = periods_col_valid(max_idx_col);   % 块宽（可能为浮点）
k_col = freq_col_valid(max_idx_col);      % 对应的频率索引
phi_col = phase_col_valid(max_idx_col);   % 相位

% 块宽取整
block_w = round(T_col);
% 计算水平起始偏移（左侧空白），使第一个整块左边界对齐
% 偏移公式：offset = -phi * T / (2*pi)，并取模到 [0, T-1]
offset_x = mod(-phi_col * T_col / (2*pi), T_col);
offset_x = round(offset_x);

fprintf('水平方向：块宽 = %d 像素，起始偏移 = %d 像素\n', block_w, offset_x);

% --- 4. 傅里叶分析竖直方向 ---
F_row = fft(row_means);
N_row = length(row_means);
amp_row = abs(F_row);
phase_row = angle(F_row);

half_row = floor(N_row/2) + 1;
amp_row_pos = amp_row(2:half_row);
phase_row_pos = phase_row(2:half_row);
freq_row = (1:length(amp_row_pos))';
periods_row = N_row ./ freq_row;

valid_idx_row = periods_row >= 30;
amp_row_valid = amp_row_pos(valid_idx_row);
periods_row_valid = periods_row(valid_idx_row);
phase_row_valid = phase_row_pos(valid_idx_row);
freq_row_valid = freq_row(valid_idx_row);

[~, max_idx_row] = max(amp_row_valid);
T_row = periods_row_valid(max_idx_row);
k_row = freq_row_valid(max_idx_row);
phi_row = phase_row_valid(max_idx_row);

block_h = round(T_row);
offset_y = mod(-phi_row * T_row / (2*pi), T_row);
offset_y = round(offset_y);

fprintf('竖直方向：块高 = %d 像素，起始偏移 = %d 像素\n', block_h, offset_y);

% --- 5. 网格分块 ---
% 提取有效区域（从偏移位置开始，按整块切割）
x_start = offset_x + 1;
y_start = offset_y + 1;

% 计算行列数
cols = floor((W - x_start + 1) / block_w);
rows = floor((H - y_start + 1) / block_h);

fprintf('网格行列数：%d 行 × %d 列 （共 %d 块）\n', rows, cols, rows*cols);

% 将每个块存入元胞数组 blocks
blocks = cell(rows, cols);
for r = 1:rows
    for c = 1:cols
        x1 = x_start + (c-1)*block_w;
        y1 = y_start + (r-1)*block_h;
        blocks{r, c} = img(y1:y1+block_h-1, x1:x1+block_w-1);
    end
end

% --- 6. 显示若干图像单元 ---
% 为便于观察，使用 montage 显示所有块，若过多则显示前 16 块
num_display = min(16, rows*cols);
display_blocks = cell(1, num_display);
count = 0;
for r = 1:rows
    for c = 1:cols
        count = count + 1;
        if count > num_display
            break;
        end
        display_blocks{count} = mat2gray(blocks{r, c}); % 归一化显示
    end
    if count > num_display
        break;
    end
end

figure('Name', '部分图像单元');
montage(display_blocks, 'Size', [NaN NaN], 'DisplayRange', []);
title(sprintf('前 %d 个图像单元 (块大小 %d×%d)', num_display, block_w, block_h));

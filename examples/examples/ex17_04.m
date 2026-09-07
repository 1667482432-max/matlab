clear;
close all;
clc;


% ex17_04.m  |  例17.4 · 模板匹配：相关找目标  |  AI 生成，已校验，R2023b
% 二维相关与匹配滤波（模板匹配）演示
% 功能：从coins.png中利用一枚已知硬币作为模板，通过归一化互相关找到该硬币在原图中的位置并标注

clear; close all;

%% 1. 读入内置灰度图 coins.png
img = imread('coins.png');          % 读入灰度图像
if ndims(img) == 3
    img = im2gray(img);             % 若为RGB则转换为灰度（coins.png本身是灰度）
end
img = im2double(img);               % 转换为双精度，便于normxcorr2计算
[rows, cols] = size(img);           % 图像尺寸

%% 2. 裁剪已知硬币作为模板 template
% 已知硬币位于矩形区域 [x=188, y=43, 宽=59, 高=56]
% 注意：MATLAB中坐标为(row, col)，即(y, x)
x = 188; y = 43; w = 59; h = 56;    % 硬币左上角坐标（x为列，y为行）及宽高
template = img(y:y+h-1, x:x+w-1);   % 裁出模板：行从y到y+h-1，列从x到x+w-1
[th, tw] = size(template);          % 模板尺寸

%% 3. 归一化互相关计算
corrMap = normxcorr2(template, img); % 计算归一化互相关矩阵
% corrMap尺寸为 (rows+th-1) × (cols+tw-1)

%% 4. 找到相关峰值并换算回原图坐标
[maxVal, maxIdx] = max(corrMap(:));                 % 峰值大小及线性索引
[ypeak_corr, xpeak_corr] = ind2sub(size(corrMap), maxIdx); % 在相关矩阵中的行列坐标

% 坐标换算：normxcorr2输出的(ypeak_corr, xpeak_corr)对应模板覆盖原图时的位置关系
% 模板左上角在原图中的坐标 = (ypeak_corr - th + 1, xpeak_corr - tw + 1)
y_match = ypeak_corr - th + 1;      % 匹配到的模板左上角在原图中的行坐标
x_match = xpeak_corr - tw + 1;      % 匹配到的模板左上角在原图中的列坐标

% 理论值应为原始裁剪坐标 [x=188, y=43]，用于验证
fprintf('匹配到的硬币左上角坐标: x = %d, y = %d\n', x_match, y_match);
fprintf('已知硬币左上角坐标:     x = %d, y = %d\n', x, y);
if x_match == x && y_match == y
    disp('峰值位置准确落在那枚已知硬币上！');
else
    disp('坐标存在偏差，请检查！');
end

%% 5. 在原图上标注匹配位置（红色矩形框）
img_annotated = img;                % 复制原图用于标注
figure;
% 使用tiledlayout创建2×2子图布局
t = tiledlayout(2, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

% 第一张：原图
nexttile;
imshow(img, []);
title('原图 (coins.png)');

% 第二张：模板（裁剪出的那枚硬币）
nexttile;
imshow(template, []);
title(sprintf('模板 (一枚完整硬币)\n[%d×%d]', tw, th));

% 第三张：归一化互相关结果图
nexttile;
imagesc(corrMap);
axis image;                         % 保持纵横比
colormap('jet'); colorbar;
title('归一化互相关结果 (normxcorr2)');
xlabel('列'); ylabel('行');
hold on;
% 在相关图上标记峰值点
plot(xpeak_corr, ypeak_corr, 'r+', 'MarkerSize', 15, 'LineWidth', 2);

% 第四张：标注匹配位置的原图
nexttile;
imshow(img_annotated, []);
title('匹配结果（红色框 = 检测到的硬币）');
hold on;
% 绘制红色矩形框，框出匹配到的硬币
rectangle('Position', [x_match, y_match, tw, th], ...
          'EdgeColor', 'r', 'LineWidth', 2, 'LineStyle', '-');
% 可在峰值左上角加一个标记便于观察
plot(x_match, y_match, 'r+', 'MarkerSize', 15, 'LineWidth', 2);
hold off;

% 整体标题
title(t, '二维归一化互相关模板匹配演示', 'FontSize', 14, 'FontWeight', 'bold');

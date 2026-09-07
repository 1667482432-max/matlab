clear;
close all;
clc;


% ex20_04.m  |  例20.4 · 相似度内核（代码精读）  |  AI 生成，已校验，R2023b
% 连连看外挂 - 离线核心：识别相同图块
% 步骤：载入图案库 -> 按布局拼图 -> 分块 -> 相似度识别 -> 输出结果

% 1. 载入图案库
load('pics.mat');  % 载入 pics 元胞数组 (1×21, 每个 51×41×3 uint8)
th = 51;           % 块高度
tw = 41;           % 块宽度

% 2. 定义已知布局
layout = [1 2 3 1;
          2 3 1 2;
          3 1 2 3];  % 3×4，使用第1,2,3种图案

% 3. 拼成盘面图 board_img
board_img = zeros(th * 3, tw * 4, 3, 'uint8');  % 预分配整张图
for i = 1:3
    for j = 1:4
        row_start = (i-1)*th + 1;
        row_end   = i*th;
        col_start = (j-1)*tw + 1;
        col_end   = j*tw;
        board_img(row_start:row_end, col_start:col_end, :) = pics{layout(i,j)};
    end
end

% 4. 分块成 3×4 个图像单元
blocks = mat2cell(board_img, repmat(th,1,3), repmat(tw,1,4), 3);

% 5. 识别相同图块，生成 idmap（严格行列对应）
idmap = zeros(3,4);      % 初始化编号矩阵
reps = {};               % 用于存储每种图案的代表块（元胞数组）

for i = 1:3
    for j = 1:4
        cur_block = double(blocks{i,j}(:));   % 当前块拉成向量
        matched = false;
        for t = 1:numel(reps)
            rep_block = double(reps{t}(:));   % 已存储的代表块向量
            dist = norm(cur_block - rep_block); % 欧氏距离
            if dist < 1e-6                    % 距离极小，视为相同图案
                idmap(i,j) = t;
                matched = true;
                break;
            end
        end
        if ~matched
            reps{end+1} = blocks{i,j};        % 添加新代表块（注意花括号）
            idmap(i,j) = numel(reps);         % 新编号
        end
    end
end

% 6. 输出结果
fprintf('识别出的不同图案种类数: %d\n', numel(reps));
disp('编号矩阵 idmap (应与layout分组一致):');
disp(idmap);

% 7. 可视化：拼板图 + 色块图
figure;
tiledlayout(1,2);

% 左图：拼好的盘面
nexttile;
imshow(board_img);
title('拼好的盘面 board\_img');

% 右图：idmap 色块图（相同编号同色）
nexttile;
imagesc(idmap);
colorbar;
axis equal tight;
title('识别结果 idmap (同色=同图案)');

% 添加格线以便看清每个格子
hold on;
for i = 1:4 % 竖直格线
    xline(i+0.5, 'k', 'LineWidth', 1);
end
for i = 1:3 % 水平格线
    yline(i+0.5, 'k', 'LineWidth', 1);
end
hold off;

clear;
close all;
clc;


% ex20_01.m  |  例20.1 · 棋盘的矩阵表示与基本操作  |  AI 生成，已校验，R2023b
% 初始棋盘
board = [3 1 2 1;
         2 0 0 3;
         1 2 3 1;
         0 3 1 2];

% ---------- 1. 计算剩余方块数 ----------
nblocks = nnz(board);               % 非零元素个数
fprintf('消除前剩余方块数: %d\n', nblocks);

% ---------- 2. 消除一对值为3的方块 ----------
% 消除 (1,1) 与 (3,3) 处的 3
board2 = board;
board2(1,1) = 0;
board2(3,3) = 0;
nblocks2 = nnz(board2);
fprintf('消除后剩余方块数: %d\n', nblocks2);

% ---------- 3. 判断是否通关 ----------
is_clear = ~any(board2(:));         % 全零则为 true
fprintf('是否通关: %d\n', is_clear);

% ---------- 绘制色块图 ----------
figure('Name', '连连看棋盘对比');

% 消除前
subplot(1,2,1);
imagesc(board);
colormap([1 1 1; jet(3)]);          % 0→白色, 1,2,3→jet 前三种颜色
caxis([0 3]);
title('消除前');
axis equal tight;
colorbar;

% 消除后
subplot(1,2,2);
imagesc(board2);
colormap([1 1 1; jet(3)]);
caxis([0 3]);
title('消除后');
axis equal tight;
colorbar;

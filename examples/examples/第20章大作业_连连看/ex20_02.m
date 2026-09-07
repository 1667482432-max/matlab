clear;
close all;
clc;


% ex20_02.m  |  例20.2 · 自动找可消对（连通判定内核）  |  AI 生成，已校验，R2023b
% 连连看可消除对扫描脚本
% 无需定义任何 function，顺序执行

% 定义测试棋盘
board = [7 7 0 0; 0 8 9 0; 0 9 8 0; 5 0 0 5];

% 获取尺寸
[rows, cols] = size(board);

% 扩展棋盘，四周补0
P = zeros(rows+2, cols+2);
P(2:rows+1, 2:cols+1) = board;

% 找出所有非零元素的位置和值
[all_r, all_c] = find(board ~= 0);
all_vals = board(board ~= 0);

% 获取不重复的图案值
uniq_vals = unique(all_vals);

% 用于存储可消除对的矩阵（每行：[row1 col1 row2 col2]）
pairs = [];

% 遍历每种图案
for v_idx = 1:length(uniq_vals)
    v = uniq_vals(v_idx);
    % 该图案所有坐标（基于原始 board）
    coords = [all_r(all_vals == v), all_c(all_vals == v)];
    n = size(coords, 1);
    % 两两配对
    for i = 1:n-1
        r1 = coords(i,1); c1 = coords(i,2);
        for j = i+1:n
            r2 = coords(j,1); c2 = coords(j,2);
            
            % 对应到扩展棋盘 P 的坐标
            pr1 = r1 + 1; pc1 = c1 + 1;
            pr2 = r2 + 1; pc2 = c2 + 1;
            
            % 临时将两端点设为 0
            tmp1 = P(pr1, pc1);
            tmp2 = P(pr2, pc2);
            P(pr1, pc1) = 0;
            P(pr2, pc2) = 0;
            
            connected = false;  % 连通标志
            
            % 情形 ①：同行或同列且直线畅通
            if pr1 == pr2  % 同行
                c_min = min(pc1, pc2);
                c_max = max(pc1, pc2);
                if sum(P(pr1, c_min:c_max) ~= 0) == 0
                    connected = true;
                end
            elseif pc1 == pc2  % 同列
                r_min = min(pr1, pr2);
                r_max = max(pr1, pr2);
                if sum(P(r_min:r_max, pc1) ~= 0) == 0
                    connected = true;
                end
            end
            
            % 情形 ②：经一个拐角，两段直线畅通
            if ~connected
                % 拐角1：(pr1, pc2)
                if P(pr1, pc2) == 0
                    % 从 (pr1,pc1) 到 (pr1,pc2) 水平段
                    c1c2_min = min(pc1, pc2);
                    c1c2_max = max(pc1, pc2);
                    % 从 (pr2,pc2) 到 (pr1,pc2) 垂直段
                    r1r2_min = min(pr1, pr2);
                    r1r2_max = max(pr1, pr2);
                    if sum(P(pr1, c1c2_min:c1c2_max) ~= 0) == 0 && ...
                       sum(P(r1r2_min:r1r2_max, pc2) ~= 0) == 0
                        connected = true;
                    end
                end
                % 拐角2：(pr2, pc1)
                if ~connected && P(pr2, pc1) == 0
                    c1c2_min = min(pc1, pc2);
                    c1c2_max = max(pc1, pc2);
                    r1r2_min = min(pr1, pr2);
                    r1r2_max = max(pr1, pr2);
                    if sum(P(pr2, c1c2_min:c1c2_max) ~= 0) == 0 && ...
                       sum(P(r1r2_min:r1r2_max, pc1) ~= 0) == 0
                        connected = true;
                    end
                end
            end
            
            % 情形 ③：枚举中间的空行或空列，三段直线畅通
            if ~connected
                % 枚举中间行
                for r = 1:(rows+2)
                    A_r = r; A_c = pc1;
                    B_r = r; B_c = pc2;
                    if P(A_r, A_c) == 0 && P(B_r, B_c) == 0
                        % 垂直段1 (pr1,pc1) 到 (r,pc1)
                        v1_min = min(pr1, r); v1_max = max(pr1, r);
                        % 水平段 (r,pc1) 到 (r,pc2)
                        h_min = min(pc1, pc2); h_max = max(pc1, pc2);
                        % 垂直段2 (r,pc2) 到 (pr2,pc2)
                        v2_min = min(pr2, r); v2_max = max(pr2, r);
                        
                        if sum(P(v1_min:v1_max, pc1) ~= 0) == 0 && ...
                           sum(P(r, h_min:h_max) ~= 0) == 0 && ...
                           sum(P(v2_min:v2_max, pc2) ~= 0) == 0
                            connected = true;
                            break;
                        end
                    end
                end
            end
            
            if ~connected
                % 枚举中间列
                for c = 1:(cols+2)
                    A_r = pr1; A_c = c;
                    B_r = pr2; B_c = c;
                    if P(A_r, A_c) == 0 && P(B_r, B_c) == 0
                        % 水平段1 (pr1,pc1) 到 (pr1,c)
                        h1_min = min(pc1, c); h1_max = max(pc1, c);
                        % 垂直段 (pr1,c) 到 (pr2,c)
                        v_min = min(pr1, pr2); v_max = max(pr1, pr2);
                        % 水平段2 (pr2,c) 到 (pr2,pc2)
                        h2_min = min(pc2, c); h2_max = max(pc2, c);
                        
                        if sum(P(pr1, h1_min:h1_max) ~= 0) == 0 && ...
                           sum(P(v_min:v_max, c) ~= 0) == 0 && ...
                           sum(P(pr2, h2_min:h2_max) ~= 0) == 0
                            connected = true;
                            break;
                        end
                    end
                end
            end
            
            % 恢复端点原始值
            P(pr1, pc1) = tmp1;
            P(pr2, pc2) = tmp2;
            
            % 如果连通，记录到 pairs（坐标使用原始 board 的行列）
            if connected
                pairs = [pairs; r1, c1, r2, c2];
            end
        end
    end
end

% 输出所有可消除对
if isempty(pairs)
    disp('没有可消除的对');
else
    disp('可消除对：');
    for k = 1:size(pairs, 1)
        r1 = pairs(k,1); c1 = pairs(k,2);
        r2 = pairs(k,3); c2 = pairs(k,4);
        val = board(r1, c1);
        fprintf('(%d,%d)-(%d,%d) value=%d\n', r1, c1, r2, c2, val);
    end
end

% 绘制色块图
figure;
imagesc(board);
% 设置颜色映射：0 为白色，其他非零值用 jet 色系
max_val = max(board(:));
if max_val == 0
    colormap([1 1 1]);
else
    cmap = jet(double(max_val));
    cmap_with_white = [1 1 1; cmap];  % 第一行对应 0
    colormap(cmap_with_white);
    caxis([0 max_val]);  % 确保 0 映射到第一个颜色
end
axis equal tight;
set(gca, 'XTick', 1:cols, 'YTick', 1:rows);
grid on;
title('连连看棋盘');
colorbar;

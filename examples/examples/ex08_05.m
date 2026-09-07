clear;
close all;
clc;


% ex08_05.m  |  例8.5 · 极点网格 → h(n)  |  AI 生成，已校验，R2023b
% 信号与系统：极点位置与单位样值响应 h(n) 的关系 —— z 平面示意图
% 极点：r = 0.5, 1.0, 1.5 ; theta = 0, pi/4, pi/2, 3*pi/4, pi
% 上半平面极点若不在实轴则自动添加共轭极点，无零点，增益为 1

clear; close all;

r_vals = [0.5, 1.0, 1.5];
theta_vals = [0, pi/4, pi/2, 3*pi/4, pi];

% ---- z 平面显示范围 ----
xmin = -1.9; xmax = 1.9;
ymin = -0.5; ymax = 2.0;

% ---- 创建图形窗口 ----
figure('Color', 'white', 'Position', [80, 80, 1100, 750]);

% ---- 背景坐标轴：单位圆、坐标轴 ----
bg_pos = [0.07, 0.07, 0.88, 0.88];  % 在 figure 中的归一化位置
ax_bg = axes('Position', bg_pos);
hold(ax_bg, 'on');

% 画单位圆
th_circle = linspace(0, 2*pi, 400);
plot(ax_bg, cos(th_circle), sin(th_circle), 'k--', 'LineWidth', 0.7);
% 画坐标轴
plot(ax_bg, [xmin xmax], [0 0], 'k-', 'LineWidth', 1);
plot(ax_bg, [0 0], [ymin ymax], 'k-', 'LineWidth', 1);
xlabel(ax_bg, 'Re(z)', 'FontSize', 11);
ylabel(ax_bg, 'Im(z)', 'FontSize', 11);
title(ax_bg, 'Pole Positions and Their Unit Sample Responses h(n)  (20 samples)', 'FontSize', 13);
axis(ax_bg, [xmin xmax ymin ymax]);
daspect(ax_bg, [1 1 1]);
grid(ax_bg, 'on');
set(ax_bg, 'XTick', -1.5:0.5:1.5, 'YTick', 0:0.5:2, 'FontSize', 9);

% ---- 子图大小（在 z 平面数据坐标中的尺寸） ----
wz = 0.42;   % 宽度
hz = 0.38;   % 高度
n_points = 20;  % impz 点数

% ---- 遍历所有 (r, theta) 组合 ----
for r = r_vals
    for th = theta_vals
        % 极点的显示位置（上半平面）
        x_p = r * cos(th);
        y_p = r * sin(th);
        
        % 构造极点向量（若不在实轴则添加共轭极点）
        if abs(sin(th)) < 1e-12   % theta = 0 或 pi
            poles = r * exp(1i*th);
        else
            poles = [r * exp(1i*th), r * exp(-1i*th)];
        end
        
        % 分母多项式系数（无零点，增益为1）
        a = poly(poles);    % 注意：返回的是 z 降幂系数，可直接用于滤波器
        b = 1;              % 分子
        
        % 计算单位样值响应前 n_points 点
        [h, n] = impz(b, a, n_points);
        
        % 将 z 平面坐标映射为 figure 归一化坐标
        norm_x = bg_pos(1) + bg_pos(3) * (x_p - xmin) / (xmax - xmin);
        norm_y = bg_pos(2) + bg_pos(4) * (y_p - ymin) / (ymax - ymin);
        width_norm  = bg_pos(3) * wz / (xmax - xmin);
        height_norm = bg_pos(4) * hz / (ymax - ymin);
        
        % 子图坐标轴位置
        pos = [norm_x - width_norm/2, norm_y - height_norm/2, ...
               width_norm, height_norm];
        
        % 创建子图坐标轴并画 stem
        ax = axes('Position', pos);
        stem(ax, n, h, 'MarkerSize', 3, 'LineWidth', 0.8);
        xlim(ax, [0 n_points-1]);
        if max(abs(h)) > 0
            y_lim = 1.2 * max(abs(h)) * [-1, 1];
            ylim(ax, y_lim);
        end
        % 简化刻度，保持清晰
        set(ax, 'XTick', [], 'YTick', [], 'Box', 'on', 'FontSize', 5);
        set(ax, 'Color', 'none');   % 透明背景，避免遮挡 z 平面元素
    end
end

% 确保背景轴也在最底层，颜色设为白色以免透明时出现网格紊乱
ax_bg.Color = 'white';
% 将背景轴置于最底层（防止 plot 被覆盖）
uistack(ax_bg, 'bottom');

clear;
close all;
clc;


% ex03_07.m  |  例3.7 · 卷积  |  AI 生成，已校验，R2023b
% 连续时间卷积 r(t) = e(t) * h(t) 的数值计算与绘图
% e(t) = u(t)-u(t-2)，h(t) = exp(-t) * u(t)
% MATLAB R2023b 兼容

dt = 0.001;                      % 采样时间间隔
t = -1:dt:10;                    % 原始时间轴 (足够观测信号与卷积)

% 定义信号 e(t) 和 h(t)
e = (t>=0) - (t>=2);             % e(t) = u(t) - u(t-2)
h = exp(-t) .* (t>=0);           % h(t) = exp(-t) * u(t)

% 数值卷积 (近似连续时间卷积)
r_full = conv(e, h) * dt;        % 卷积结果乘以 dt 得到连续卷积近似
tr_full = t(1) + t(1) + (0:length(r_full)-1) * dt; % 卷积对应的时间轴

% 指定输出变量
r = r_full;                      % 卷积结果存入 r
tr = tr_full;                    % 对应时间轴存入 tr

% 绘图：三个子图纵向排列，加高画布
figure('Position', [100, 100, 900, 1050]);   % 高度 3*350

% 子图1：e(t)
subplot(3,1,1);
plot(t, e, 'b', 'LineWidth', 2);
grid on;
xlabel('t (秒)', 'FontSize', 24);
ylabel('e(t)', 'FontSize', 24);
title('输入信号 e(t) = u(t)-u(t-2)', 'FontSize', 24);
set(gca, 'FontSize', 24);
xlim([t(1), t(end)]);

% 子图2：h(t)
subplot(3,1,2);
plot(t, h, 'r', 'LineWidth', 2);
grid on;
xlabel('t (秒)', 'FontSize', 24);
ylabel('h(t)', 'FontSize', 24);
title('冲激响应 h(t) = e^{-t} u(t)', 'FontSize', 24);
set(gca, 'FontSize', 24);
xlim([t(1), t(end)]);

% 子图3：r(t)
subplot(3,1,3);
plot(tr, r, 'k', 'LineWidth', 2);
grid on;
xlabel('t (秒)', 'FontSize', 24);
ylabel('r(t)', 'FontSize', 24);
title('卷积结果 r(t) = e(t) * h(t)', 'FontSize', 24);
set(gca, 'FontSize', 24);
xlim([t(1), t(end)]);            % 与上两图对齐时间轴范围

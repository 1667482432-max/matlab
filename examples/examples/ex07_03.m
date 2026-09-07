clear;
close all;
clc;


% ex07_03.m  |  例7.3 · 零输入／零状态／完全响应  |  AI 生成，已校验，R2023b
% 离散系统零输入、零状态与完全响应的计算和对比
clear; close all;

% 系统系数
b = 0.05;                % 分子系数
a = [1, -0.9, 0.3];      % 分母系数 a(1)=1

% 时间索引 n = 0,1,...,20
n = 0:20;
N = length(n);
x = ones(1, N);          % 单位阶跃激励

% ---------- 第一组初始条件 y(-1)=0, y(-2)=1 ----------
Y1 = [0, 1];                     % 初始输出条件 [y(-1), y(-2)]
zi1 = filtic(b, a, Y1);          % 由初始条件得到的等效初始状态

y_zi1 = filter(b, a, zeros(1,N), zi1);   % 零输入响应
y_zs1 = filter(b, a, x);                 % 零状态响应（初始状态为0）
y_full1 = filter(b, a, x, zi1);          % 完全响应

% 验证线性叠加性质
err1 = max(abs(y_zi1 + y_zs1 - y_full1));
disp(['第一组零输入+零状态与完全响应之差的最大值：', num2str(err1)]);

% ---------- 第二组初始条件 y(-1)=1, y(-2)=0 ----------
Y2 = [1, 0];
zi2 = filtic(b, a, Y2);

y_zi2 = filter(b, a, zeros(1,N), zi2);
y_zs2 = filter(b, a, x);                 % 零状态响应（与第一组相同）
y_full2 = filter(b, a, x, zi2);

err2 = max(abs(y_zi2 + y_zs2 - y_full2));
disp(['第二组零输入+零状态与完全响应之差的最大值：', num2str(err2)]);

% ----------------- 绘图对比 -----------------
figure('Position', [100, 100, 900, 700]);   % 两个子图，适当加高

% 第一组
subplot(2,1,1);
stem(n, y_zi1, 'Color', 'b', 'LineWidth', 2, 'LineStyle', '-'); hold on;
stem(n, y_zs1, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--');
stem(n, y_full1, 'Color', 'k', 'LineWidth', 2, 'LineStyle', ':');
hold off;
grid on;
set(gca, 'FontSize', 24);
xlabel('n', 'FontSize', 24);
ylabel('响应', 'FontSize', 24);
title('第一组: y(-1)=0, y(-2)=1', 'FontSize', 24);
legend('零输入响应', '零状态响应', '完全响应', 'FontSize', 24, 'Location', 'best');

% 第二组
subplot(2,1,2);
stem(n, y_zi2, 'Color', 'b', 'LineWidth', 2, 'LineStyle', '-'); hold on;
stem(n, y_zs2, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--');
stem(n, y_full2, 'Color', 'k', 'LineWidth', 2, 'LineStyle', ':');
hold off;
grid on;
set(gca, 'FontSize', 24);
xlabel('n', 'FontSize', 24);
ylabel('响应', 'FontSize', 24);
title('第二组: y(-1)=1, y(-2)=0', 'FontSize', 24);
legend('零输入响应', '零状态响应', '完全响应', 'FontSize', 24, 'Location', 'best');

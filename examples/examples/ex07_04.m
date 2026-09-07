clear;
close all;
clc;


% ex07_04.m  |  例7.4 · 单位样值与阶跃响应  |  AI 生成，已校验，R2023b
% 离散系统差分方程：y(n) - 0.5 y(n-1) + 0.6 y(n-2) = x(n) - 0.3 x(n-2)
% 用两种方法求0~10的单位样值响应h和单位阶跃响应g，并比较结果

% 差分方程系数
a = [1, -0.5, 0.6];   % y的系数
b = [1, 0, -0.3];     % x的系数

N = 11;               % 响应点数
n = 0:N-1;            % 时间序号

%% 方法一：filter 函数
delta = [1, zeros(1,N-1)];          % 单位样值序列
u = ones(1,N);                      % 单位阶跃序列
h1 = filter(b, a, delta);           % 单位样值响应
g1 = filter(b, a, u);               % 单位阶跃响应

%% 方法二：impz 和 stepz 函数
[h2, ~] = impz(b, a, N);            % 单位样值响应
[g2, ~] = stepz(b, a, N);           % 单位阶跃响应

%% 比较两种方法的结果是否一致
err_h = max(abs(h1 - h2(:)'));      % 单位样值响应最大误差
err_g = max(abs(g1 - g2(:)'));      % 单位阶跃响应最大误差
disp(['单位样值响应两种方法最大误差：', num2str(err_h)]);
disp(['单位阶跃响应两种方法最大误差：', num2str(err_g)]);

% 将最终响应存入要求的变量
h = h1;  % 单位样值响应
g = g1;  % 单位阶跃响应

%% 绘制比较图（纵向排列两个子图）
figure('Position', [100, 100, 900, 350*2]);

% 子图1：单位样值响应对比
subplot(2,1,1);
stem(n, h1, 'b', 'LineWidth', 2, 'DisplayName', '方法一 (filter)');
hold on;
stem(n, h2, 'r--', 'LineWidth', 2, 'DisplayName', '方法二 (impz)');
hold off;
grid on;
set(gca, 'FontSize', 24);
xlabel('n', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('单位样值响应 h(n) 比较', 'FontSize', 24);
legend('Location', 'best', 'FontSize', 24);

% 子图2：单位阶跃响应对比
subplot(2,1,2);
stem(n, g1, 'b', 'LineWidth', 2, 'DisplayName', '方法一 (filter)');
hold on;
stem(n, g2, 'r--', 'LineWidth', 2, 'DisplayName', '方法二 (stepz)');
hold off;
grid on;
set(gca, 'FontSize', 24);
xlabel('n', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('单位阶跃响应 g(n) 比较', 'FontSize', 24);
legend('Location', 'best', 'FontSize', 24);

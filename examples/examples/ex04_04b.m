clear;
close all;
clc;


% ex04_04b.m  |  例4.4 · 数值法·矩阵化  |  AI 生成，已校验，R2023b
% 定义时间轴和信号
t = -1:0.001:1;
dt = t(2) - t(1);
w = -8*pi:0.01:8*pi;
f = double(abs(t) < 0.5);      % 居中矩形脉冲，宽度1

%% 方法1：按定义循环计算频谱
tic;
F = zeros(1, length(w));
for k = 1:length(w)
    F(k) = sum(f .* exp(-1j*w(k)*t)) * dt;
end
t_loop = toc;

%% 方法2：一次矩阵运算
tic;
E = exp(-1j * w.' * t);         % 变换矩阵，行对应频点，列对应时刻
F_matrix = (E * f.') * dt;      % 一步得到所有频点的频谱
t_matrix = toc;

%% 显示运行时间
fprintf('循环方法运行时间：%.4f 秒\n', t_loop);
fprintf('矩阵方法运行时间：%.4f 秒\n', t_matrix);

%% 绘图比较两种结果的幅度谱
figure;
plot(w, abs(F), 'b-', 'LineWidth', 2);      % 循环结果，蓝色实线
hold on;
plot(w, abs(F_matrix), 'r--', 'LineWidth', 2); % 矩阵结果，红色虚线
hold off;
grid on;
set(gca, 'FontSize', 24);
xlabel('\omega (rad/s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('幅度谱比较', 'FontSize', 24);
legend('循环方法', '矩阵方法', 'FontSize', 24);

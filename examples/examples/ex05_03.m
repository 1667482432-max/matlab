clear;
close all;
clc;


% ex05_03.m  |  例5.3 · H(s)·tf+lsim  |  AI 生成，已校验，R2023b
% 清空环境，避免残留变量干扰
clear; clc; close all;

% 定义时间向量，从0到10秒，步长足够小以保证波形光滑
t = 0:0.01:10;

% 定义激励信号 e(t) = sin(3t)
e = sin(3 * t);

% 定义系统传递函数 H(s) = 1/(0.1s + 0.1)
num = 1;
den = [0.1, 0.1];
H = tf(num, den);

% 计算零状态响应（初始状态为零），使用lsim
y = lsim(H, e, t);

% 按题目要求将响应的数值波形存入变量 i
i = y;

% 绘制激励与响应的对比图
figure;
plot(t, e, 'b-', 'LineWidth', 2); hold on;
plot(t, i, 'r-', 'LineWidth', 2); hold off;
grid on;
xlabel('时间 t (s)', 'FontSize', 24);
ylabel('幅值', 'FontSize', 24);
title('正弦激励与零状态响应', 'FontSize', 24);
legend('e(t) = sin(3t)', 'i(t) (零状态响应)', 'FontSize', 24);
set(gca, 'FontSize', 24);

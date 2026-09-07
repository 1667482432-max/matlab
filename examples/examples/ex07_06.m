clear;
close all;
clc;


% ex07_06.m  |  例7.6 · 解卷积  |  AI 生成，已校验，R2023b
% 反求单位样值响应 h(n)
N = 10;                     % 取输出序列前 N 点
n_y = 0:N-1;
y = 0.5.^n_y;               % y(n) = 0.5^n u(n)
x = [1, 0.5];               % 输入序列非零值

% 用 deconv 求 h(n)
[h, r] = deconv(y, x);
n = 0:length(h)-1;          % h 对应的序号

% 绘制单位样值响应
figure;
stem(n, h, 'b', 'LineWidth', 2);
xlabel('n', 'FontSize', 24);
ylabel('h(n)', 'FontSize', 24);
title('单位样值响应 h(n)', 'FontSize', 24);
set(gca, 'FontSize', 24);
grid on;

% 验证：计算卷积并与理论输出比较
y_conv = conv(h, x);
y_conv = y_conv(1:N);       % 截取前 N 点，与 y 等长

figure;
stem(n_y, y, 'b', 'LineWidth', 2); hold on;
stem(n_y, y_conv, 'r--', 'LineWidth', 2);
xlabel('n', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('验证: y(n) 与 conv(h,x) 比较', 'FontSize', 24);
legend('y(n) 理论值', 'conv(h,x)', 'FontSize', 24);
set(gca, 'FontSize', 24);
grid on;

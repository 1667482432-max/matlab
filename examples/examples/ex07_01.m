clear;
close all;
clc;


% ex07_01.m  |  例7.1 · 差分方程完全解  |  AI 生成，已校验，R2023b
% 求解常系数线性差分方程 y(n) - y(n-1) + 0.24*y(n-2) = x(n) - x(n-1)
% 激励 x(n)=n^2 (n>=0), x(n)=0 (n<0)
% 初始条件 y(-1)=-1, y(-2)=-2
% 计算 n=0 到 20 的输出序列

N = 20;                     % 最大时间序号
n = 0:N;                    % 时间序号存入 n
y = zeros(1, N+1);          % 输出序列预分配

% 定义因果激励函数
x = @(k) (k>=0) .* (k.^2);

% 已知的初始输出值
ym2 = -2;   % y(-2)
ym1 = -1;   % y(-1)

% 递推计算 y(0) ~ y(20)
for k = 0:N
    if k == 0
        y0 = x(0) - x(-1) + ym1 - 0.24*ym2;  % 利用初始条件 y(-1), y(-2)
        y(k+1) = y0;
        ym2 = ym1;      % 更新 y(-1) -> 下一步的 y(-2)
        ym1 = y0;       % 更新 y(0)  -> 下一步的 y(-1)
    else
        yn = x(k) - x(k-1) + ym1 - 0.24*ym2;
        y(k+1) = yn;
        ym2 = ym1;      % y(k-2) <= y(k-1)
        ym1 = yn;       % y(k-1) <= y(k)
    end
end

% 绘制输出序列
figure;
stem(n, y, 'b', 'LineWidth', 2, 'MarkerSize', 6);
grid on;
xlabel('n', 'FontSize', 24);
ylabel('y(n)', 'FontSize', 24);
title('差分方程完全解 y(n)', 'FontSize', 24);
set(gca, 'FontSize', 24);

clear;
close all;
clc;


% ex09_01.m  |  例9.1 · DTFT 的数值计算  |  AI 生成，已校验，R2023b
% 数值计算序列 x(n) = (1/2)^n * u(n) 的 DTFT
% 并在 [-2π, 2π] 范围内绘制幅度谱和相位谱

% 参数设置
N = 60;                     % 截断长度，0到N-1，足够小尾项可忽略
w = linspace(-2*pi, 2*pi, 2000);  % 频率向量（行向量）
n = (0:N-1).';              % 序列索引（列向量）

% 定义序列 x(n)
x = (0.5).^n;               % x(n) = (1/2)^n, n>=0

% DTFT 数值计算：X(e^{jw}) = sum_{n} x(n) * exp(-j w n)
% 使用矩阵乘法，一次性对所有 w 计算
X = x.' * exp(-1j * n * w);   % 结果 X 为 1×length(w) 行向量

% 计算幅度和相位
X_mag = abs(X);             % 幅度谱
X_phase = unwrap(angle(X)); % 相位谱（解相位包裹）

% 绘图：纵向两个子图
figure('Position', [100, 100, 900, 700]);  % 画布 900×700 (350*2)
subplot(2,1,1);
plot(w, X_mag, 'b', 'LineWidth', 2);      % 蓝曲线
grid on;
set(gca, 'FontSize', 24);
xlabel('频率 \omega (rad)', 'FontSize', 24);
ylabel('|X(e^{j\omega})|', 'FontSize', 24);
title('幅度谱', 'FontSize', 24);

subplot(2,1,2);
plot(w, X_phase, 'r', 'LineWidth', 2);    % 红曲线
grid on;
set(gca, 'FontSize', 24);
xlabel('频率 \omega (rad)', 'FontSize', 24);
ylabel('相位 (rad)', 'FontSize', 24);
title('相位谱', 'FontSize', 24);

clear;
close all;
clc;


% ex04_07.m  |  例4.7 · 卷积定理  |  AI 生成，已校验，R2023b
% 参数设定
Trg = [-1, 1];         % 时域范围（覆盖三角脉冲和矩形脉冲）
N = 2048;              % 时域采样点数
OMGrg = [-40*pi, 40*pi]; % 频域范围
K = 4096;              % 频域采样点数

% 调用 prefourier 准备变换矩阵
[t, omg, FT, IFT] = prefourier(Trg, N, OMGrg, K);

% 生成三角脉冲 f(t) = 1 - 2|t|, |t|<0.5
f = (1 - 2*abs(t)) .* (abs(t) < 0.5);

% 生成矩形脉冲 g(t) = sqrt(2), |t|<0.25  (其自卷积恰为三角脉冲)
g = sqrt(2) * (abs(t) < 0.25);

% 方法1：直接傅里叶变换（按定义）
F_dir = FT * f(:);

% 方法2：卷积定理（矩形脉冲谱的平方）
G = FT * g(:);
F_conv = G .* G;

% 逆变换回时域
f_dir_rec = real(IFT * F_dir);
f_conv_rec = real(IFT * F_conv);

% 绘图
figure('Position', [100, 100, 900, 700]);

% 子图1：频谱幅度比较
subplot(2,1,1);
plot(omg, abs(F_dir), 'b-', 'LineWidth', 2); hold on;
plot(omg, abs(F_conv), 'r--', 'LineWidth', 2); hold off;
grid on;
xlabel('\omega', 'FontSize', 24);
ylabel('|F(\omega)|', 'FontSize', 24);
title('频谱幅度比较', 'FontSize', 24);
legend('直接定义', '卷积定理', 'FontSize', 24);
set(gca, 'FontSize', 24);

% 子图2：时域信号比较
subplot(2,1,2);
plot(t, f, 'k-', 'LineWidth', 2); hold on;
plot(t, f_dir_rec, 'b--', 'LineWidth', 2);
plot(t, f_conv_rec, 'r:', 'LineWidth', 2); hold off;
grid on;
xlabel('t', 'FontSize', 24);
ylabel('f(t)', 'FontSize', 24);
title('时域信号比较', 'FontSize', 24);
legend('原三角脉冲', '直接定义', '卷积定理', 'FontSize', 24);
set(gca, 'FontSize', 24);

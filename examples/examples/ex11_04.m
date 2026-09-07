clear;
close all;
clc;


% ex11_04.m  |  例11.4 · 矩形脉冲的带宽失真  |  AI 生成，已校验，R2023b
% 矩形脉冲通过两个不同带宽的理想低通滤波器，观察波形变化
% 需要 prefourier 函数在 MATLAB 路径中

% --- 参数设置 ---
tau = 2;               % 矩形脉冲宽度（时域）
Trg = [-4, 4];         % 时间范围
N = 2000;              % 时域采样点数
OMGrg = [-30, 30];     % 频率范围 (rad/s)
K = 4000;              % 频域采样点数
wc1 = 3;               % 较窄的理想低通截止频率
wc2 = 6;               % 较宽的理想低通截止频率（约为wc1的两倍）

% --- 生成矩形脉冲 ---
[t, omg, FT, IFT] = prefourier(Trg, N, OMGrg, K);
x = zeros(N, 1);
x(abs(t) <= tau/2) = 1;   % 中心在 t=0，幅度为1的矩形脉冲

% --- 频域理想低通滤波器 ---
H1 = double(abs(omg) <= wc1);  % 窄带低通
H2 = double(abs(omg) <= wc2);  % 宽带低通

% --- 频域滤波 ---
Xf = FT * x;           % 输入信号的频谱
Yf1 = Xf .* H1;        % 窄带输出频谱
Yf2 = Xf .* H2;        % 宽带输出频谱

% --- 逆变换回时域 ---
y1 = real(IFT * Yf1);  % 窄带输出时域波形（虚部为数值误差，取实部）
y2 = real(IFT * Yf2);  % 宽带输出时域波形

% --- 绘图对比 ---
figure('Position', [100 100 900 600]);
plot(t, x, 'b-', 'LineWidth', 2); hold on;
plot(t, y1, 'r--', 'LineWidth', 2);
plot(t, y2, 'k:', 'LineWidth', 2);
hold off;
grid on;
set(gca, 'FontSize', 24);
xlabel('时间 (s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('矩形脉冲及其经过不同带宽理想低通后的波形', 'FontSize', 24);
legend({'输入脉冲', ['窄带输出 (ω_c = ', num2str(wc1), ')'], ...
        ['宽带输出 (ω_c = ', num2str(wc2), ')']}, ...
       'Location', 'northoutside', 'FontSize', 24);

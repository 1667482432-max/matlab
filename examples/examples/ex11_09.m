clear;
close all;
clc;


% ex11_09.m  |  例11.9 · FM 调制：瞬时频率与贝塞尔边频谱  |  AI 生成，已校验，R2023b
% 单音调频（FM）信号及其频谱演示
% 载波角频率 wc = 100 rad/s，基带 cos(5t)，频偏25，调制指数5
wc = 100; wm = 5; dw = 25; beta = dw / wm;       % beta = 5
T = 2*pi / wm;                                    % 周期约1.2566 s

% 设定分析参数（整周期截断）
N_per = 10;                                       % 分析10个周期
Trg = [0, N_per * T];                             % 时间范围
N = 5000;                                         % 时间采样点数
OMGrg = [60, 140];                                % 关心角频率范围
K = 1000;                                         % 频率点数

% 调用 prefourier 生成时间轴、频率轴与变换矩阵
[t, omg, FT, ~] = prefourier(Trg, N, OMGrg, K);

% 生成 FM 信号 s(t) = cos(∫ wi(tau)d tau)
s = cos(wc*t + (dw/wm)*sin(wm*t));                % 相位积分

% 利用傅里叶变换矩阵计算频谱 S
S = FT * s;

% ----- 绘图 -----
figure('Position', [100, 100, 900, 700]);         % 加高画布

% 子图1：s(t) 波形（取前两个周期，观察疏密变化）
subplot(2, 1, 1);
idx = t <= 2*T;                                   % 只显示 0~2T 时间段
plot(t(idx), s(idx), 'b-', 'LineWidth', 2); grid on;
xlabel('时间 (s)'); ylabel('幅度');
title('单音调频信号 s(t) (部分波形)');
set(gca, 'FontSize', 24);

% 子图2：频谱 |S(ω)|
subplot(2, 1, 2);
plot(omg, abs(S), 'b-', 'LineWidth', 2); grid on;
xlabel('角频率 \omega (rad/s)'); ylabel('|S(\omega)|');
title('单音调频信号频谱 |S(\omega)|');
set(gca, 'FontSize', 24);

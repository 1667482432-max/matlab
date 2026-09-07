clear;
close all;
clc;


% ex12_01.m  |  例12.1 · 抽样致频谱周期重复（欠采样混叠 vs 满足奈奎斯特）  |  AI 生成，已校验，R2023b
% 数值傅里叶方法观察抽样频率对频谱的影响
% 构造带限信号（带宽 B=1 Hz，频谱三角形），用低于和高于奈奎斯特率的抽样频率抽样，
% 对比两抽样信号的频谱，观察频谱周期交叠情况。

clear; close all;

% ========== 1. 构造带限信号 ==========
B = 1;                       % 基带带宽 (Hz)，奈奎斯特频率为 2 Hz
T0 = 20;                     % 时域截断半径 (s)
Nt = 2^14;                   % 时域点数
OMGmax = 2*pi*10;            % 角频率范围 [-10 Hz, 10 Hz]
K = 2048;                    % 频域点数

% 调用 prefourier 获取时频网格和变换矩阵
[t, omg, FT, IFT] = prefourier([-T0, T0], Nt, [-OMGmax, OMGmax], K);

% 构建频域三角形频谱（带限于 |f| <= B）
f = omg/(2*pi);
Xf = (1 - abs(f)/B) .* (abs(f) <= B);   % 最大幅度 1，三角形下降
Xf = Xf(:);                              % 确保列向量

% 逆傅里叶变换得到时域信号
x = IFT * Xf;                            % IFT * Xf 得到时域近似
x = real(x);                             % 消除数值误差导致的微小虚部

% ========== 2. 两种抽样频率下的抽样 ==========
fs1 = 1.5;               % 低于奈奎斯特率 (欠采样)
fs2 = 4;                 % 高于奈奎斯特率 (过采样)

Ts1 = 1/fs1;  Ts2 = 1/fs2;

% 在截断区间内生成抽样时刻
n1 = (-floor(T0/Ts1) : floor(T0/Ts1)).';
n2 = (-floor(T0/Ts2) : floor(T0/Ts2)).';
t1 = n1 * Ts1;    t2 = n2 * Ts2;

% 用样条插值得到抽样信号（信号在边界外置零）
xs1 = interp1(t, x, t1, 'spline', 0);
xs2 = interp1(t, x, t2, 'spline', 0);

% 转为行向量以方便后续矩阵运算
xs1 = xs1(:).';
xs2 = xs2(:).';

% ========== 3. 计算抽样信号的频谱（DTFT） ==========
Fmax = 10;                   % 观察的频率范围 [-10 Hz, 10 Hz]
Nf = 2000;
f_plot = linspace(-Fmax, Fmax, Nf).';   % 频率列向量

% 频谱计算： Σ x[n] exp(-j 2π f n Ts)
Xspec1 = sum(xs1 .* exp(-1j*2*pi*f_plot*(n1.'*Ts1)), 2);
Xspec2 = sum(xs2 .* exp(-1j*2*pi*f_plot*(n2.'*Ts2)), 2);

% ========== 4. 绘图对比 ==========
figure;
plot(f_plot, abs(Xspec1), '-', 'Color', [0 0 0.8], 'LineWidth', 2);  % 蓝色实线
hold on;
plot(f_plot, abs(Xspec2), '--', 'Color', [0.8 0 0], 'LineWidth', 2); % 红色虚线
grid on;
legend('f_s=1.5 Hz (欠采样)', 'f_s=4 Hz (过采样)', 'Location','best');
xlabel('频率 (Hz)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('抽样信号频谱对比：欠采样与过采样', 'FontSize', 24);
set(gca, 'FontSize', 24);

clear;
close all;
clc;


% ex12_02.m  |  例12.2 · 零阶保持的频谱失真（Sa 下垂与镜像）  |  AI 生成，已校验，R2023b
% 零阶保持失真的数值傅里叶分析演示
% 带限信号：频域三角形（tripuls），带宽 f_max = 1 Hz
% 抽样率：fs = 1.2 × 奈奎斯特率 = 2.4 Hz
% 比较原信号与零阶保持信号的波形及幅度谱

clear; close all;

% ========= 参数定义 =========
f_max = 1;                  % 信号带宽 (Hz)
omega_max = 2*pi*f_max;     % 对应角频率 (rad/s)
fs = 1.2 * (2*f_max);       % 抽样频率，奈奎斯特率的 1.2 倍
Ts = 1/fs;                  % 抽样间隔

% 时间轴设定
Trg = [-10, 10];            % 截断区间，保证时域衰减足够
N = 20000;                  % 时间采样点数（偶数，便于有零频点）
% 频率轴设定，覆盖到约3倍抽样频率
f_limit = 3*fs;
omega_limit = 2*pi*f_limit;
OMGrg = [-omega_limit, omega_limit];
K = 20000;                  % 频率点数（偶数，使 omg 包含 0）

% ========= 获取傅里叶变换矩阵 =========
[t, omg, FT, IFT] = prefourier(Trg, N, OMGrg, K);

% ========= 构造频域三角形（带限信号频谱） =========
X_omega = tripuls(omg, 2*omega_max, 0);   % 列向量

% ========= 逆变换得到时域带限信号 =========
x_orig = real(IFT * X_omega);              % 原连续信号近似

% ========= 抽样并零阶保持 =========
t_samp = t(1):Ts:t(end);                   % 抽样时刻
x_samp = interp1(t, x_orig, t_samp, 'linear'); % 抽取样值
x_zoh = interp1(t_samp, x_samp, t, 'previous', 'extrap'); % 零阶保持

% ========= 绘制时域波形 =========
figure('Position', [100, 100, 900, 700]);

subplot(2,1,1);
plot(t, x_orig, 'b-', 'LineWidth', 2); hold on;
plot(t, x_zoh, 'r--', 'LineWidth', 2);
hold off; grid on;
set(gca, 'FontSize', 24);
xlabel('时间 (s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('原信号与零阶保持信号波形', 'FontSize', 24);
legend('原带限信号', '零阶保持信号', 'FontSize', 24);

% ========= 计算幅度谱并归一化（零频对齐） =========
X_orig_spec = FT * x_orig;
X_zoh_spec  = FT * x_zoh;

A_orig = abs(X_orig_spec);
A_zoh  = abs(X_zoh_spec);

[~, idx0] = min(abs(omg));             % 最接近零频的索引
A_orig_norm = A_orig / A_orig(idx0);
A_zoh_norm  = A_zoh  / A_zoh(idx0);

f_Hz = omg / (2*pi);                   % 转为 Hz 便于观察

% ========= 绘制幅度谱对比 =========
subplot(2,1,2);
plot(f_Hz, A_orig_norm, 'b-', 'LineWidth', 2); hold on;
plot(f_Hz, A_zoh_norm,  'r--', 'LineWidth', 2);
hold off; grid on;
xlim([-3*fs, 3*fs]);                   % 展示到约3倍抽样频率
set(gca, 'FontSize', 24);
xlabel('频率 (Hz)', 'FontSize', 24);
ylabel('归一化幅度', 'FontSize', 24);
title('幅度谱对比（零频归一化）', 'FontSize', 24);
legend('原信号谱', '零阶保持信号谱', 'FontSize', 24);

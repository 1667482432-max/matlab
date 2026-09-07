clear;
close all;
clc;


% ex11_11.m  |  例11.11 · 频分复用 FDM  |  AI 生成，已校验，R2023b
% 频分复用（FDM）数值傅里叶演示
% 三路基带信号：m1=cos(10t), m2=cos(20t), m3=cos(30t)
% 载波：100, 160, 220 rad/s，DSB调制，合成 FDM 信号 s

% ----- 参数设置 -----
T_total = 20;               % 总仿真时间（保证频率分辨率约 0.314 rad/s）
N = 2^14;                   % 时域采样点数
Trg = [0, T_total];
OMG_max = 300;              % 频谱显示范围 [-300, 300] rad/s
K = 2^12;                   % 频域点数
OMGrg = [-OMG_max, OMG_max];

% 调用预定义函数，获得时间向量、频率向量、正反傅里叶变换矩阵
[t, omg, FT, IFT] = prefourier(Trg, N, OMGrg, K);

% ----- 生成信号 -----
m1 = cos(10 * t);
m2 = cos(20 * t);
m3 = cos(30 * t);

% DSB 调制
s1 = m1 .* cos(100 * t);
s2 = m2 .* cos(160 * t);
s3 = m3 .* cos(220 * t);
s  = s1 + s2 + s3;          % FDM 合成信号

% ----- 图1：合成信号 s 的幅度谱 -----
S = FT * s;                 % 傅里叶变换（列向量）

figure('Position', [100, 100, 900, 400]);
plot(omg, abs(S), 'LineWidth', 2);
grid on;
xlabel('角频率 \omega (rad/s)', 'FontSize', 24);
ylabel('|S(\omega)|', 'FontSize', 24);
title('FDM 合成信号 s 的幅度谱', 'FontSize', 24);
set(gca, 'FontSize', 24);

% ----- 接收端：提取第2路信号（载频 160 rad/s） -----
% 理想带通滤波器：保留 130 ~ 190 rad/s 及其负频率镜像
BP_mask = (omg >= 130 & omg <= 190) | (omg <= -130 & omg >= -190);
S_bp = S .* BP_mask;
s_bp = real(IFT * S_bp);            % 逆变换回时域

% 相干解调：乘以同频载波
s_demod = s_bp .* cos(160 * t);

% 理想低通滤波器：截止角频率 40 rad/s
S_demod = FT * s_demod;
LP_mask = (omg >= -40 & omg <= 40);
S_demod_filt = S_demod .* LP_mask;
m2_r = real(IFT * S_demod_filt);    % 恢复的基带信号

% ----- 图2：恢复的 m2 与原始 m2 对比 -----
% 仅绘制前 2 秒以清晰观察
idx_plot = find(t <= 2);
t_plot = t(idx_plot);

figure('Position', [100, 100, 900, 400]);
plot(t_plot, m2(idx_plot), 'b-', 'LineWidth', 2, ...
     'DisplayName', '原始 m_2');
hold on;
plot(t_plot, m2_r(idx_plot), 'r--', 'LineWidth', 2, ...
     'DisplayName', '恢复 m_2');
xlabel('时间 t (s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('第2路信号：相干解调恢复结果', 'FontSize', 24);
legend('Location', 'best', 'FontSize', 24);
grid on;
set(gca, 'FontSize', 24);
hold off;

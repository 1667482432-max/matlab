clear;
close all;
clc;


% ex04_05.m  |  例4.5 · 单周期正弦·频谱看四性质  |  AI 生成，已校验，R2023b
% 参数设置
T_pulse = 0.2;                % 正弦脉冲周期
Trg = [-0.4, 0.4];            % 时间范围，需覆盖展宽信号
N = 2048;                     % 时间采样点数
OMGrg = [-400, 400];          % 角频率范围（rad/s），覆盖频移后的高频成分
K = 2048;                     % 频率采样点数

% 调用 prefourier 获得时间、频率向量及正变换矩阵
[t, omg, FT, ~] = prefourier(Trg, N, OMGrg, K);
dt = t(2) - t(1);

% 构造原始信号 f(t) = sin(2*pi*t/T_pulse)  (|t|<T_pulse/2)
f = zeros(N, 1);
idx = abs(t) < T_pulse/2;
f(idx) = sin(2*pi * t(idx) / T_pulse);

% 原始信号幅度谱
F_orig = FT * f;
amp_orig = abs(F_orig);

%% 1. 尺度变换：f(1.5t) 与 f(0.7t)
f_1_5 = zeros(N, 1);
t1 = 1.5 * t;
idx1 = abs(t1) < T_pulse/2;
f_1_5(idx1) = sin(2*pi * t1(idx1) / T_pulse);
F_1_5 = FT * f_1_5;
amp_1_5 = abs(F_1_5);

f_0_7 = zeros(N, 1);
t2 = 0.7 * t;
idx2 = abs(t2) < T_pulse/2;
f_0_7(idx2) = sin(2*pi * t2(idx2) / T_pulse);
F_0_7 = FT * f_0_7;
amp_0_7 = abs(F_0_7);

%% 2. 频移：f(t)*cos(2*pi*20*t)
f_mod = f .* cos(2*pi*20 * t);
F_mod = FT * f_mod;
amp_mod = abs(F_mod);

%% 3. 时域微分：数值微分
df = gradient(f, dt);
F_diff = FT * df;
amp_diff = abs(F_diff);

%% 4. 时域积分：数值累积积分并去除直流
integ = cumtrapz(t, f);
integ = integ - mean(integ);   % 去除零频分量，凸显积分性质
F_int = FT * integ;
amp_int = abs(F_int);

%% 绘图
figure('Position', [100, 100, 1000, 800]);

% 子图1：尺度变换
subplot(2,2,1);
plot(omg, amp_orig, 'b-', 'LineWidth', 2); hold on;
plot(omg, amp_1_5, 'r--', 'LineWidth', 2);
plot(omg, amp_0_7, 'k:', 'LineWidth', 2);
grid on;
set(gca, 'FontSize', 24);
xlabel('\omega (rad/s)', 'FontSize', 24);
ylabel('|F(\omega)|', 'FontSize', 24);
title('尺度变换性质', 'FontSize', 24);
legend('f(t)', 'f(1.5t)', 'f(0.7t)', 'FontSize', 24, 'Interpreter', 'tex');

% 子图2：频移
subplot(2,2,2);
plot(omg, amp_orig, 'b-', 'LineWidth', 2); hold on;
plot(omg, amp_mod, 'r--', 'LineWidth', 2);
grid on;
set(gca, 'FontSize', 24);
xlabel('\omega (rad/s)', 'FontSize', 24);
ylabel('|F(\omega)|', 'FontSize', 24);
title('频移性质', 'FontSize', 24);
legend('f(t)', 'f(t)cos(2\pi20t)', 'FontSize', 24, 'Interpreter', 'tex');

% 子图3：微分
subplot(2,2,3);
plot(omg, amp_orig, 'b-', 'LineWidth', 2); hold on;
plot(omg, amp_diff, 'r--', 'LineWidth', 2);
grid on;
set(gca, 'FontSize', 24);
xlabel('\omega (rad/s)', 'FontSize', 24);
ylabel('|F(\omega)|', 'FontSize', 24);
title('时域微分性质', 'FontSize', 24);
legend('f(t)', 'df/dt', 'FontSize', 24, 'Interpreter', 'tex');

% 子图4：积分
subplot(2,2,4);
plot(omg, amp_orig, 'b-', 'LineWidth', 2); hold on;
plot(omg, amp_int, 'r--', 'LineWidth', 2);
grid on;
set(gca, 'FontSize', 24);
xlabel('\omega (rad/s)', 'FontSize', 24);
ylabel('|F(\omega)|', 'FontSize', 24);
title('时域积分性质', 'FontSize', 24);
legend('f(t)', '\int f dt (去直流)', 'FontSize', 24, 'Interpreter', 'tex');

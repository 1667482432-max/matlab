clear;
close all;
clc;


% ex04_01.m  |  例4.1 · 方波三角级数  |  AI 生成，已校验，R2023b
% 周期方波的三角形式傅里叶级数数值求解与重构
% 方波周期 T1=1，零均值；一个周期 (-0.5, 0.5) 内，|t|<0.25 取 +0.5，其余 -0.5

close all; clear; clc;

%% 参数与密集采样
T = 1;                 % 周期
N_samples = 1e5;       % 一个周期内的采样点数（密集）
t1 = linspace(-0.5, 0.5, N_samples);   % 一个周期的时间向量

% 生成一个周期内的方波信号
x1 = 0.5 * (abs(t1) < 0.25) + (-0.5) * (abs(t1) >= 0.25);

%% 按定义数值积分求傅里叶系数（三角形式）
% 直流分量 a0（注意：T=1，省略分母）
a0 = trapz(t1, x1);    % 理论上 a0 = 0

K = 10;                % 最高谐波次数
a = zeros(1, K);
b = zeros(1, K);

for k = 1:K
    % a_k = (2/T) ∫ x(t) cos(2π k t / T) dt
    a(k) = 2 * trapz(t1, x1 .* cos(2*pi*k*t1));
    % b_k = (2/T) ∫ x(t) sin(2π k t / T) dt
    b(k) = 2 * trapz(t1, x1 .* sin(2*pi*k*t1));
end

%% 绘制傅里叶系数图
figure('Position', [100, 100, 800, 500]);
stem(1:K, a, 'b', 'LineWidth', 2, 'MarkerSize', 8);  % 蓝色实心圆
hold on;
stem(1:K, b, 'r--', 'LineWidth', 2, 'MarkerSize', 8); % 红色虚线空心
xlabel('谐波次数 {\it k}', 'FontSize', 24);
ylabel('系数值', 'FontSize', 24);
title('三角形式傅里叶系数 a_k 与 b_k', 'FontSize', 24);
legend('a_k', 'b_k', 'FontSize', 24);
grid on;
set(gca, 'FontSize', 24);
hold off;

%% 用直流项加前5次谐波重构方波，并与原信号对比
t_plot = linspace(-1.5, 1.5, 3000);   % 画3个周期
% 原始方波：通过周期延拓生成
t_mod = mod(t_plot + 0.5, T) - 0.5;
x_orig = 0.5 * (abs(t_mod) < 0.25) + (-0.5) * (abs(t_mod) >= 0.25);

% 重构信号：直流 + 前5次谐波
x_recon = a0;   % 直流，理论值为0
for k = 1:5
    x_recon = x_recon + a(k)*cos(2*pi*k*t_plot) + b(k)*sin(2*pi*k*t_plot);
end

figure('Position', [100, 100, 900, 500]);
plot(t_plot, x_orig, 'b-', 'LineWidth', 2);   % 原始曲线，蓝色实线
hold on;
plot(t_plot, x_recon, 'r--', 'LineWidth', 2); % 重构曲线，红色虚线
xlabel('时间 {\it t}', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('原始方波与前5次谐波重构对比', 'FontSize', 24);
legend('原始方波', '5次谐波重构', 'FontSize', 24);
grid on;
set(gca, 'FontSize', 24);
hold off;

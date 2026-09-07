clear;
close all;
clc;


% ex04_04a.m  |  例4.4 · 数值法·按定义  |  AI 生成，已校验，R2023b
% 矩形脉冲的傅里叶变换数值计算与重构
clear; clc;

% 时域采样
dt = 0.001;                      % 时间步长
t = -0.5:dt:0.5;                % 矩形脉冲区间
f = ones(size(t));              % 脉冲值均为1

% 频率范围与步长
w = linspace(-8*pi, 8*pi, 2000);
dw = w(2) - w(1);

% 按定义数值计算频谱 F(w) = ∫ f(t) e^{-jwt} dt
F_w = zeros(size(w));
for k = 1:length(w)
    F_w(k) = sum(f .* exp(-1j*w(k)*t)) * dt;
end

% ---------- 幅度谱与相位谱 ----------
figure('Position', [100 100 900 350*2]);
subplot(2,1,1)
plot(w, abs(F_w), 'b', 'LineWidth', 2);
xlabel('频率 \omega (rad/s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('矩形脉冲幅度谱', 'FontSize', 24);
grid on;
set(gca, 'FontSize', 24);

subplot(2,1,2)
plot(w, angle(F_w), 'r', 'LineWidth', 2);
xlabel('频率 \omega (rad/s)', 'FontSize', 24);
ylabel('相位 (rad)', 'FontSize', 24);
title('矩形脉冲相位谱', 'FontSize', 24);
grid on;
set(gca, 'FontSize', 24);

% ---------- 用数值频谱重构时域信号 ----------
t_recon = -2:0.01:2;            % 重构用的时间向量
f_recon = zeros(size(t_recon)); % 重构信号初始化
for k = 1:length(t_recon)
    integrand = F_w .* exp(1j*w*t_recon(k));
    f_recon(k) = trapz(w, integrand) / (2*pi);
end

% 原信号在重构时间网格上的精确值
f_orig = double(abs(t_recon) <= 0.5);

% ---------- 原信号与重构信号对比 ----------
figure('Position', [100 100 900 350]);
plot(t_recon, f_orig, 'b-', 'LineWidth', 2); hold on;
plot(t_recon, real(f_recon), 'r--', 'LineWidth', 2);
xlabel('时间 t (s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('原信号与重构信号对比', 'FontSize', 24);
legend('原信号 f(t)', '重构信号 f_{re}(t)', 'Location', 'best', 'FontSize', 24);
grid on;
set(gca, 'FontSize', 24);

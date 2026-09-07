clear;
close all;
clc;


% ex09_02.m  |  例9.2 · 时移与频移性质  |  AI 生成，已校验，R2023b
% DTFT时移与频移性质数值验证
% 序列 x(n) = (1/2)^n u(n)
% 频率范围 w ∈ [-pi, pi]

close all; clear;

% 参数设置
N = 30;                     % 序列长度 n = 0,1,...,N
n = 0:N;
x = (1/2).^n;               % 原始序列

% 时移序列 x(n-3)
x_shift3 = zeros(1, N+1);
x_shift3(4:end) = x(1:end-3);   % n>=3 时值为 (1/2)^(n-3)，其余为零

% 频移序列 (-1)^n x(n) = e^{jπ n} x(n)
x_mod = (-1).^n .* x;

% DTFT 频率向量（偶数个点，不含 π 的重复点）
M = 1000;                   % 频率采样点数
w = linspace(-pi, pi, M+1);
w = w(1:M);                 % ω ∈ [-π, π)

% 构造 DTFT 矩阵并计算频谱
X_orig   = x * exp(-1j * n(:) * w);       % 1×M
X_shift3 = x_shift3 * exp(-1j * n(:) * w);
X_mod    = x_mod * exp(-1j * n(:) * w);

%% ---- 时移性质验证：幅度谱、相位谱及相位差 ----
figure('Position', [100, 100, 900, 350*3]);

% 子图1：幅度谱对比
subplot(3,1,1);
plot(w/pi, abs(X_orig),   'b-', 'LineWidth', 2); hold on;
plot(w/pi, abs(X_shift3), 'r--', 'LineWidth', 2); hold off;
grid on;
xlabel('\omega / \pi', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('幅度谱', 'FontSize', 24);
legend('x(n)', 'x(n-3)', 'FontSize', 24, 'Location', 'best');
set(gca, 'FontSize', 24);

% 子图2：相位谱对比
subplot(3,1,2);
plot(w/pi, angle(X_orig),   'b-', 'LineWidth', 2); hold on;
plot(w/pi, angle(X_shift3), 'r--', 'LineWidth', 2); hold off;
grid on;
xlabel('\omega / \pi', 'FontSize', 24);
ylabel('相位 (rad)', 'FontSize', 24);
title('相位谱', 'FontSize', 24);
legend('x(n)', 'x(n-3)', 'FontSize', 24, 'Location', 'best');
set(gca, 'FontSize', 24);

% 子图3：相位差
phase_diff = unwrap(angle(X_shift3) - angle(X_orig));
subplot(3,1,3);
plot(w/pi, phase_diff, 'k-', 'LineWidth', 2);
grid on;
xlabel('\omega / \pi', 'FontSize', 24);
ylabel('相位差 (rad)', 'FontSize', 24);
title('相位谱之差 (x(n-3) - x(n))', 'FontSize', 24);
set(gca, 'FontSize', 24);

%% ---- 频移性质验证 ----
figure('Position', [100, 100, 900, 350*2]);

% 子图1：原始与调制信号幅度谱直接对比
subplot(2,1,1);
plot(w/pi, abs(X_orig), 'b-', 'LineWidth', 2); hold on;
plot(w/pi, abs(X_mod),  'r--', 'LineWidth', 2); hold off;
grid on;
xlabel('\omega / \pi', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('幅度谱：x(n) 与 (-1)^n x(n)', 'FontSize', 24);
legend('|X(e^{j\omega})|', '|X(e^{j(\omega-\pi)})|', ...
       'FontSize', 24, 'Location', 'best');
set(gca, 'FontSize', 24);

% 子图2：频移 π（循环移位半个频段）后的原始频谱与调制频谱比较
X_orig_shifted = circshift(X_orig, M/2);   % ω → ω-π 对应的离散循环移位
subplot(2,1,2);
plot(w/pi, abs(X_orig_shifted), 'k-', 'LineWidth', 2); hold on;
plot(w/pi, abs(X_mod),          'r--', 'LineWidth', 2); hold off;
grid on;
xlabel('\omega / \pi', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('循环移位后的原始频谱与调制信号频谱', 'FontSize', 24);
legend('循环移位后的|X|', '|调制信号频谱|', ...
       'FontSize', 24, 'Location', 'best');
set(gca, 'FontSize', 24);

% 计算并显示最大绝对误差
max_err = max(abs( abs(X_orig_shifted) - abs(X_mod) ));
disp(['循环移位频谱与调制频谱幅度的最大绝对误差 = ', num2str(max_err)]);

clear;
close all;
clc;


% ex11_05.m  |  例11.5 · 系统函数约束特性（hilbert 重建虚部）  |  AI 生成，已校验，R2023b
% 验证因果系统系统函数实部与虚部之间的约束
% h(t) = exp(-t) u(t)
% 用 prefourier 求 H(jw)，再由实部重建 H1，逆变换得 h1(t)

% ----- 参数设置 -----
Trg    = [-2, 10];         % 时间范围，包含负时间以观察因果性
N      = 4096;             % 时间采样点数
OMGrg  = [-40, 40];        % 频率范围
K      = 4096;             % 频率采样点数

% 调用 prefourier 获得 t, omg, 变换矩阵 FT 和 IFT
[t, omg, FT, IFT] = prefourier(Trg, N, OMGrg, K);

% ----- 原冲激响应 h(t) -----
h_true = exp(-t) .* (t >= 0);          % 因果指数信号

% ----- 原系统函数 H(jw) -----
H = FT * h_true;                       % 正向数值傅里叶变换

% ----- 由实部 R = real(H) 重建完整频谱 H1 -----
R = real(H);
X_recon = -imag(hilbert(R));           % 因果约束：虚部 = -Hilbert{实部}
H1 = R + 1i * X_recon;

% ----- 逆变换得到重建冲激响应 h1(t) -----
h1_complex = IFT * H1;                 % 数值逆傅里叶变换
h1 = real(h1_complex);                 % 理论上应为实信号，取实部
residual_imag_h1 = imag(h1_complex);   % 残余虚部

% ----- 关键数值输出 -----
[~, idx1] = min(abs(omg - 1));
[~, idx2] = min(abs(omg - 2));

fprintf('w=1 处重建虚部 imag(H1) = %.6f\n', imag(H1(idx1)));
fprintf('w=2 处重建虚部 imag(H1) = %.6f\n', imag(H1(idx2)));
fprintf('逆变换 h1 残余虚部的最大模 = %.6e\n', max(abs(residual_imag_h1)));

% ----- 绘图：冲激响应对比 -----
figure;
plot(t, h_true, 'b-', 'LineWidth', 2); hold on;
plot(t, h1, 'r--', 'LineWidth', 2);
xlabel('t', 'FontSize', 24);
ylabel('h(t)', 'FontSize', 24);
title('冲激响应对比: 原 h(t) 与重建 h1(t)', 'FontSize', 24);
legend('原 h(t)', '重建 h1(t)', 'FontSize', 24);
set(gca, 'FontSize', 24);
grid on;

% ----- 绘图：系统函数对比（幅度和相位）-----
figure('Position', [100, 100, 900, 700]);

subplot(2,1,1);
plot(omg, abs(H), 'b-', 'LineWidth', 2); hold on;
plot(omg, abs(H1), 'r--', 'LineWidth', 2);
xlabel('\omega', 'FontSize', 24);
ylabel('|H(j\omega)|', 'FontSize', 24);
title('系统函数幅度对比', 'FontSize', 24);
legend('原 H', '重建 H1', 'FontSize', 24);
set(gca, 'FontSize', 24);
grid on;

subplot(2,1,2);
plot(omg, angle(H), 'b-', 'LineWidth', 2); hold on;
plot(omg, angle(H1), 'r--', 'LineWidth', 2);
xlabel('\omega', 'FontSize', 24);
ylabel('相位 (rad)', 'FontSize', 24);
title('系统函数相位对比', 'FontSize', 24);
legend('原 H', '重建 H1', 'FontSize', 24);
set(gca, 'FontSize', 24);
grid on;

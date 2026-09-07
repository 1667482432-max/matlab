clear;
close all;
clc;


% ex09_03.m  |  例9.3 · 用 fft 算连续傅里叶变换  |  AI 生成，已校验，R2023b
% 矩形脉冲傅里叶变换，比较 fft/ifft 与矩阵乘法两种方法
clear; close all;

% ===== 参数 =====
Trg = [-1, 1];                  % 时域范围
N = 100;                        % 抽样点数
T = Trg(2) - Trg(1);            % 时域宽度
OMG = 2*pi*N / T;               % 由 OMG*T = 2*pi*N 确定的频域总范围
OMGrg = [-OMG/2, OMG/2];        % 对称的频域范围
K = N;                          % 频域抽样点数

% ===== 获取变换矩阵（调用已写好的 prefourier） =====
[t, omg, FT, IFT] = prefourier(Trg, N, OMGrg, K);

% ===== 构造矩形脉冲 f(t) = 1, |t|<1/2 =====
f = zeros(N,1);
f(abs(t) < 0.5) = 1;

% ===== 方法1：矩阵乘法 =====
F1 = FT * f;                    % 频谱
f1 = IFT * F1;                 % 恢复的时域信号（应为实信号）

% ===== 方法2：fft / ifft =====
% 使 t=0 对应 fft 的第一个元素（ifftshift）
f_shifted = ifftshift(f);
% 正向 fft，乘以系数 T/N，使其与 FT 矩阵一致
F2_raw = fft(f_shifted) * (T/N);
% 将频谱搬移到对称频率（与 omg 对应）
F2 = fftshift(F2_raw);

% 逆变换：先反搬移，再 ifft，并补偿系数
F2_raw_unshifted = ifftshift(F2);
f2_shifted = ifft(F2_raw_unshifted * (N/T));   % ifft 后恢复至无时移的顺序
f2 = fftshift(f2_shifted);                     % 恢复到原始 t 的顺序（实信号）

% ===== 误差计算 =====
err_spectrum = norm(F1 - F2);
err_time = norm(f1 - f2);
disp(['频谱误差范数：', num2str(err_spectrum)]);
disp(['时域恢复误差范数：', num2str(err_time)]);

% ===== 绘图 =====
figure('Position',[100 100 900 700]);

% --- 频谱幅度对比 ---
subplot(2,1,1);
plot(omg, abs(F1), 'b-', 'LineWidth',2); hold on;
plot(omg, abs(F2), 'r--', 'LineWidth',2);
xlabel('\omega (rad/s)');
ylabel('|F(\omega)|');
title('矩形脉冲频谱幅度对比');
legend('矩阵法','fft法', 'Location','best');
grid on;
set(gca, 'FontSize',24);

% --- 时域恢复信号对比 ---
subplot(2,1,2);
plot(t, real(f1), 'b-', 'LineWidth',2); hold on;
plot(t, real(f2), 'r--', 'LineWidth',2);
xlabel('t (s)');
ylabel('f(t)');
title('两种方法恢复的时域信号');
legend('矩阵逆变换','ifft', 'Location','best');
grid on;
set(gca, 'FontSize',24);

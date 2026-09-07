clear;
close all;
clc;


% ex11_01.m  |  例11.1 · RC 低通网络对矩形脉冲的响应  |  AI 生成，已校验，R2023b
% 参数设置
R = 1;
C = 0.3;
alpha = 1/(R*C);               % 系统参数 alpha = 1/RC
Trg = [-0.5, 3];              % 时域观察范围
N = 2048;                     % 时域采样点数
OMGrg = [-100, 100];          % 频域观察范围
K = 2048;                     % 频域采样点数

% 获取变换矩阵和坐标向量
[t, omg, FT, IFT] = prefourier(Trg, N, OMGrg, K);

% 输入信号 v1(t) —— 0 < t < 0.5 为 1，其余为 0
v1 = double(t > 0 & t < 0.5);

% 频谱计算
V1 = FT * v1;                     % 输入频谱
H = alpha ./ (alpha + 1j*omg);    % 系统频率响应
V2 = H .* V1;                     % 输出频谱

% 时域信号反变换
v2 = real(IFT * V2);              % 输出信号 v2(t)
h = real(IFT * H);                % 冲激响应 h(t)

% 绘图
figure('Position', [100, 100, 900, 700]);

% 第一行：时域波形
subplot(2,3,1);
plot(t, v1, 'b', 'LineWidth', 2);
xlabel('t (s)'); ylabel('v_1(t)');
title('输入矩形脉冲 v_1(t)');
grid on; set(gca, 'FontSize', 24);

subplot(2,3,2);
plot(t, v2, 'r', 'LineWidth', 2);
xlabel('t (s)'); ylabel('v_2(t)');
title('输出响应 v_2(t)');
grid on; set(gca, 'FontSize', 24);

subplot(2,3,3);
plot(t, h, 'k', 'LineWidth', 2);
xlabel('t (s)'); ylabel('h(t)');
title('冲激响应 h(t)');
grid on; set(gca, 'FontSize', 24);

% 第二行：幅度谱
subplot(2,3,4);
plot(omg, abs(H), 'b', 'LineWidth', 2);
xlabel('\omega (rad/s)'); ylabel('|H(\omega)|');
title('系统幅度响应 |H(\omega)|');
grid on; set(gca, 'FontSize', 24);

subplot(2,3,5);
plot(omg, abs(V1), 'r', 'LineWidth', 2);
xlabel('\omega (rad/s)'); ylabel('|V_1(\omega)|');
title('输入幅度谱 |V_1(\omega)|');
grid on; set(gca, 'FontSize', 24);

subplot(2,3,6);
plot(omg, abs(V2), 'k', 'LineWidth', 2);
xlabel('\omega (rad/s)'); ylabel('|V_2(\omega)|');
title('输出幅度谱 |V_2(\omega)|');
grid on; set(gca, 'FontSize', 24);

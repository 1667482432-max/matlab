clear;
close all;
clc;


% ex11_07.m  |  例11.7 · DSB-SC 与相干解调  |  AI 生成，已校验，R2023b
%% DSB-SC 调制与相干解调数值傅里叶演示
% 基带信号 g(t) = 3cos(10t) + 2cos(20t)，载波 cos(100t)
% 调制：f(t) = g(t)cos(100t)
% 解调：f(t)cos(100t) 后经理想低通 (|ω|<30) 得到 g1(t)
% 使用提供好的 prefourier 函数进行数值傅里叶变换

% ----- 参数设置 -----
Trg = [0, 2*pi];          % 时间范围
N = 2000;                 % 时域采样点数
OMGrg = [-150, 150];      % 频域范围 (需覆盖最高频率约 120 rad/s)
K = 2000;                 % 频域采样点数

% 调用 prefourier 获取时/频向量与变换矩阵
[t, omg, FT, IFT] = prefourier(Trg, N, OMGrg, K);

% ----- 构造信号 -----
g = 3*cos(10*t) + 2*cos(20*t);      % 基带信号 (N×1)
f = g .* cos(100*t);                % DSB-SC 调制信号

% ----- 数值傅里叶变换得到频谱 -----
G = FT * g;                         % 基带频谱 (K×1)
F = FT * f;                         % 已调频谱 (K×1)

% ----- 相干解调 -----
fd = f .* cos(100*t);               % 乘以相干载波
Fd = FT * fd;                       % 解调前频谱

% 理想低通滤波器 |ω| < 30
H = double(abs(omg) < 30);          % 频域滤波器 (K×1)
G1 = H .* Fd;                       % 滤波后的频谱
g1 = IFT * G1;                      % 逆变换得到解调基带 (N×1)
% 注意：理论解调输出为 0.5*g(t)，此处无额外缩放，直接展示

% ===== 绘图 =====
% 纵向 3 对子图：左列时域波形，右列幅度谱
figure('Position', [100, 100, 900, 350*3]);

% --- 基带 ---
subplot(3,2,1)
plot(t, g, 'b', 'LineWidth',2);
xlabel('t');
ylabel('g(t)');
title('基带信号 g(t)');
grid on; set(gca, 'FontSize',24);

subplot(3,2,2)
plot(omg, abs(G), 'b', 'LineWidth',2);
xlabel('\omega');
ylabel('|G(\omega)|');
title('基带幅度谱 |G(\omega)|');
grid on; set(gca, 'FontSize',24);

% --- 已调信号 ---
subplot(3,2,3)
plot(t, f, 'r', 'LineWidth',2);
xlabel('t');
ylabel('f(t)');
title('DSB-SC 调制信号 f(t)');
grid on; set(gca, 'FontSize',24);

subplot(3,2,4)
plot(omg, abs(F), 'r', 'LineWidth',2);
xlabel('\omega');
ylabel('|F(\omega)|');
title('调制信号幅度谱 |F(\omega)|');
grid on; set(gca, 'FontSize',24);

% --- 解调恢复信号 ---
subplot(3,2,5)
plot(t, g1, 'k', 'LineWidth',2);
xlabel('t');
ylabel('g_1(t)');
title('解调恢复信号 g_1(t)');
grid on; set(gca, 'FontSize',24);

subplot(3,2,6)
plot(omg, abs(G1), 'k', 'LineWidth',2);
xlabel('\omega');
ylabel('|G_1(\omega)|');
title('解调信号幅度谱 |G_1(\omega)|');
grid on; set(gca, 'FontSize',24);

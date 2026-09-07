clear;
close all;
clc;


% ex11_03.m  |  例11.3 · 理想低通的冲激响应（Sa·非因果）  |  AI 生成，已校验，R2023b
% 理想低通滤波器冲激响应的数值傅里叶计算
wc = 10;                     % 截止频率
t0 = 1;                      % 线性相位延时
Trg = [-2, 4];               % 时间范围（秒）
N = 1000;                    % 时间样本点数
OMGrg = [-30, 30];           % 频率范围（rad/s），覆盖 [-wc, wc] 并留余量
K = 2000;                    % 频率样本点数

% 调用预定义函数，生成时间、频率向量及变换矩阵
[t, omg, ~, IFT] = prefourier(Trg, N, OMGrg, K);

% 构造理想低通滤波器的频率响应 H(jω)
% 幅频：|ω| < wc 时取 1，否则取 0
% 相频：线性相位 -ω*t0
H = double(abs(omg) < wc) .* exp(-1j * omg * t0);

% 数值逆傅里叶变换得到冲激响应
h = IFT * H;                 % h 理论上为实信号，数值误差会引起微小虚部
h = real(h);                 % 取实部

% 绘制冲激响应波形
figure('Position', [100, 100, 900, 420]);
plot(t, h, 'b', 'LineWidth', 2);
grid on;
xlabel('t (s)', 'FontSize', 24);
ylabel('h(t)', 'FontSize', 24);
title('理想低通滤波器冲激响应（数值傅里叶方法）', 'FontSize', 24);
set(gca, 'FontSize', 24);

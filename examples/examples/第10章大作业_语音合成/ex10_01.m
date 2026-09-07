clear;
close all;
clc;


% ex10_01.m  |  例10.1 · 声道：全极点系统与共振峰  |  AI 生成，已校验，R2023b
clear; close all; clc;

% ========== 系统参数 ==========
a1 = 1.3789;
a2 = -0.9506;
Fs = 8000;          % 采样频率 (Hz)

% ========== 传递函数 H(z) ==========
b = [1];            % 分子系数 (全极点)
a = [1, -a1, -a2];  % 分母系数

fprintf('===== 传递函数 H(z) =====\n');
fprintf('分子 B(z) = 1\n');
fprintf('分母 A(z) = 1 - %.4f z^{-1} + %.4f z^{-2}\n', a1, -a2);

% ========== 求极点与共振峰频率 ==========
poles = roots(a);   % 求极点
fprintf('\n极点: %.4f ± %.4f j\n', real(poles(1)), abs(imag(poles(1))));

% 取共轭对中辐角为正的极点（位于上半平面）
[~, idx] = max(angle(poles));  % 找角度最大的极点（正频率）
p = poles(idx);
f_res = angle(p) / (2*pi) * Fs;  % 共振峰频率 (Hz)
fprintf('共振峰频率: %.2f Hz\n', f_res);

% ========== 图1: 零极点图 ==========
figure('Name', '零极点图');
zplane(b, a);
title('零极点图');
grid on;

% ========== 图2: 频率响应 ==========
figure('Name', '频率响应');
freqz(b, a, 1024, Fs);  % 直接绘制，频率轴为 Hz
title('频率响应（幅度与相位）');

% ========== 图3: 单位样值响应 (impz) ==========
figure('Name', '单位样值响应');
impz(b, a, 50, Fs);    % 绘制50个样本点
title('单位样值响应（impz）');
grid on;

% ========== 图4: filter 与 impz 结果对比 ==========
N = 50;                         % 响应长度
delta = [1; zeros(N-1, 1)];     % 单位冲激序列
h_filter = filter(b, a, delta); % 用 filter 计算单位样值响应

[h_imp, t_imp] = impz(b, a, N, Fs);  % 从 impz 获取数据用于对比

figure('Name', 'impz 与 filter 对比');
stem(t_imp, h_imp, 'b', 'LineWidth', 1.5, 'DisplayName', 'impz');
hold on;
n = (0:N-1)' / Fs;              % filter 结果的时间轴（秒）
stem(n, h_filter, '--r', 'LineWidth', 1.0, 'DisplayName', 'filter');
hold off;
xlabel('时间 (s)');
ylabel('幅值');
title('单位样值响应对比：impz 与 filter');
legend('Location', 'best');
grid on;

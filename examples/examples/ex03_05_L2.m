clear;
close all;
clc;


% ex03_05_L2.m  |  例3.5 · L2 引导求解  |  AI 生成，已校验，R2023b
% 连续LTI系统状态空间模型
A = [-1 -1; 4 -6];
B = [1; 0];
C = [-1 0];
D = 1;

% --- 确定起始状态 ---
% t<0 时输入恒为2且系统已达稳态，状态导数 dx/dt=0，
% 即 A*x0 + B*2 = 0，解得 x0 = -2 * inv(A)*B
x0 = -2 * (A \ B);   % 列向量

% 时间向量 (t>=0)，采样间隔0.01s
t = (0:0.01:5)';    % 列向量
% t>=0 时的输入恒为4
u = 4 * ones(size(t));

% 构造状态空间系统对象
sys = ss(A, B, C, D);

% --- 零输入响应 ---
% 输入恒为零，初始状态为 x0
izi = lsim(sys, zeros(size(t)), t, x0);

% --- 零状态响应 ---
% 初始状态为零，输入为 u
izs = lsim(sys, u, t);

% --- 完全响应 ---
% 初始状态为 x0，输入为 u
ifull = lsim(sys, u, t, x0);

% 验证叠加性：完全响应 = 零输入响应 + 零状态响应
err = max(abs(ifull - (izi + izs)));
disp(['叠加性验证最大绝对误差：', num2str(err)]);

% --- 绘图对比 ---
figure;
plot(t, izi, '--', 'Color', [0 0 1], 'LineWidth', 2);  % 蓝色虚线
hold on;
plot(t, izs, ':', 'Color', [1 0 0], 'LineWidth', 2);   % 红色点线
plot(t, ifull, '-', 'Color', [0 0 0], 'LineWidth', 2); % 黑色实线
hold off;
grid on;

% 字体与标注设置（24 pt）
set(gca, 'FontSize', 24);
xlabel('时间 (s)', 'FontSize', 24);
ylabel('系统输出', 'FontSize', 24);
title('零输入、零状态与完全响应', 'FontSize', 24);
legend('零输入响应', '零状态响应', '完全响应', 'FontSize', 24);

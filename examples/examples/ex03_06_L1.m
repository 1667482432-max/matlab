clear;
close all;
clc;


% ex03_06_L1.m  |  例3.6 · L1 受控复现  |  AI 生成，已校验，R2023b
% 连续LTI系统：i''(t)+7i'(t)+10i(t) = e''(t)+6e'(t)+4e(t)
% 用tf和lsim求冲激响应与阶跃响应（不使用impulse/step）

% 1. 建立系统模型
sys = tf([1, 6, 4], [1, 7, 10]);

% 2. 时间向量
dt = 0.01;
t = 0:dt:5;

% 3. 阶跃响应
u = ones(size(t));                % 阶跃信号 t>=0 取1
g = lsim(sys, u, t);             % 阶跃响应

% 4. 冲激响应（用窄脉冲近似冲激，面积=1）
d = zeros(size(t));
d(1) = 1/dt;                     % 高度=1/dt，使面积约为1
h = lsim(sys, d, t);             % 冲激响应

% 5. 绘制冲激响应与阶跃响应
figure;
plot(t, h, 'b-', 'LineWidth',2); hold on;
plot(t, g, 'r--', 'LineWidth',2);
grid on;
xlabel('时间 (s)', 'FontSize',24);
ylabel('响应', 'FontSize',24);
title('冲激响应与阶跃响应', 'FontSize',24);
legend('冲激响应 h', '阶跃响应 g', 'FontSize',24);
set(gca, 'FontSize',24);

% 6. 去掉t=0冲激尖峰，显示主体部分
figure;
plot(t(2:end), h(2:end), 'b-', 'LineWidth',2); hold on;
plot(t(2:end), g(2:end), 'r--', 'LineWidth',2);
grid on;
xlabel('时间 (s)', 'FontSize',24);
ylabel('响应', 'FontSize',24);
title('冲激响应（无尖峰）与阶跃响应', 'FontSize',24);
legend('冲激响应 h', '阶跃响应 g', 'FontSize',24);
set(gca, 'FontSize',24);

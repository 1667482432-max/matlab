clear;
close all;
clc;


% ex03_04.m  |  例3.4 · lsim 特解  |  AI 生成，已校验，R2023b
% 系统微分方程: r''(t) + 2r'(t) + 3r(t) = e'(t) + e(t)
% 传递函数: H(s) = (s+1) / (s^2 + 2s + 3)

num = [1 1];          % 分子系数：s + 1
den = [1 2 3];        % 分母系数：s^2 + 2s + 3
sys = tf(num, den);   % 建立传递函数模型

t = 0:0.1:10;         % 时间向量 0~10秒，步长0.1

% 输入1: e(t) = t^2
e1 = t.^2;
r1 = lsim(sys, e1, t);  % 零初始条件响应

% 输入2: e(t) = exp(t)
e2 = exp(t);
r2 = lsim(sys, e2, t);

% 绘图：两个纵向子图
figure('Position', [100, 100, 900, 700]);  % 画布高度350*2=700

subplot(2,1,1);
plot(t, r1, 'b-', 'LineWidth', 2);
xlabel('t (s)');
ylabel('r_1(t)');
title('系统对输入 e(t)=t^2 的响应');
grid on;
set(gca, 'FontSize', 24);

subplot(2,1,2);
plot(t, r2, 'r-', 'LineWidth', 2);
xlabel('t (s)');
ylabel('r_2(t)');
title('系统对输入 e(t)=exp(t) 的响应');
grid on;
set(gca, 'FontSize', 24);

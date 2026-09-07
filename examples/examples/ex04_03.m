clear;
close all;
clc;


% ex04_03.m  |  例4.3 · 幅度谱/相位谱  |  AI 生成，已校验，R2023b
% 信号 f(t) = exp(-2*t)*u(t) 的傅里叶变换及频谱绘制
% 作者：MATLAB R2023b
% 描述：使用符号运算求傅里叶变换 F(w)，并绘制幅度谱与相位谱

clear; clc;

% 定义符号变量
syms t w

% 定义信号 f(t) = exp(-2*t) * u(t)，其中 u(t) 为阶跃函数
f = exp(-2*t) * heaviside(t);

% 求傅里叶变换 F(w)
Fw = fourier(f, t, w);

% 显示变换结果
disp('傅里叶变换 F(w) = ')
disp(Fw)

% 绘制幅度谱与相位谱
% 画布高度按子图数加高，避免过扁
figure('Position',[100 100 900 700]);

% 子图1：幅度谱 |F(w)|
subplot(2,1,1);
fplot(abs(Fw), [-30 30], 'LineWidth', 2, 'Color', [0 0 1]); % 深蓝色
xlabel('w (rad/s)');
ylabel('|F(w)|');
title('幅度谱');
grid on;
set(gca, 'FontSize', 24);

% 子图2：相位谱 angle(F(w))
subplot(2,1,2);
fplot(angle(Fw), [-30 30], 'LineWidth', 2, 'Color', [1 0 0]); % 深红色
xlabel('w (rad/s)');
ylabel('相位 (rad)');
title('相位谱');
grid on;
set(gca, 'FontSize', 24);

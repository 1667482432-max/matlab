%% 第1课：时间轴、变量、点运算与绘图（仅需 MATLAB）
% 操作：先完整运行，再每次只改一处参数，预测变化后运行。
clear;
close all;
clc;

fs = 100;                       % 每秒采样100次
t = 0:1/fs:1;                  % 包含两个端点，共101点
f = 3;                         % 正弦频率，单位Hz
x = sin(2*pi*f*t);             % 对每个时间点计算一次正弦
y = exp(-t).*x;                % 同位置相乘，形成衰减正弦

figure('Name','Lesson 1');
subplot(2,1,1);
plot(t,x,'LineWidth',1.5);
grid on; xlabel('t / s'); ylabel('x(t)'); title('3 Hz sine');
subplot(2,1,2);
plot(t,y,'LineWidth',1.5);
grid on; xlabel('t / s'); ylabel('y(t)'); title('Decaying sine');

% 练习A：f改成5，先预测1秒中有几个周期。
% 练习B：把x乘2，比较周期和幅值分别怎么变。
% 练习C：在命令窗口输入numel(t)、t(1)、x(1)。
% 基准预期：101、0、0。

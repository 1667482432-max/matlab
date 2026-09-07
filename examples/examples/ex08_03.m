clear;
close all;
clc;


% ex08_03.m  |  例8.3 · 零状态响应  |  AI 生成，已校验，R2023b
% 清理工作区与命令窗口
clear; clc;

% 定义符号变量
syms a b n z
assume(n, 'integer');      % 设定 n 为整数（采样点）
assumeAlso(n >= 0);        % 因果序列，n >= 0

% 激励 x(n) = a^n (n>=0)
x_n = a^n;

% 对激励进行 z 变换
X_z = ztrans(x_n, n, z);

% 系统差分方程: y(n) - b*y(n-1) = x(n)
% 对方程两边进行 z 变换，利用零状态条件得系统函数
% H(z) = Y(z)/X(z) = 1 / (1 - b*z^{-1}) = z / (z - b)
H_z = 1 / (1 - b * z^(-1));

% 计算零状态响应的 z 变换 Y(z) = H(z) * X(z)
Y_z = simplify(H_z * X_z);

% 逆 z 变换得到时域响应 y(n)
y_n = iztrans(Y_z, z, n);

% 化简结果并存入变量 y
y = simplify(y_n);

% 显示结果
disp('零状态响应 y(n) = ');
disp(y);

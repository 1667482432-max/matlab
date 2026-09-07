clear;
close all;
clc;


% ex08_04.m  |  例8.4 · 完全响应  |  AI 生成，已校验，R2023b
% 清空环境
clear; clc;

% 定义符号变量
% a, b 为符号常量；n 为整数时间变量（n>=0）；z 为 Z 变换复变量
syms a b z
syms n integer
assumeAlso(n >= 0)

% 激励 x(n) = a^n (n>=0) 的单边 Z 变换（手动指定标准闭合形式，避免分段条件）
Xz = z/(z - a);

% 起始条件
y_neg1 = 2;

% 设 y(n) 的 Z 变换为 Yz
syms Yz

% 单边 Z 变换位移性质：Z{y(n-1)} = z^{-1}*Yz + y(-1)
% 差分方程：y(n) - b*y(n-1) = x(n)  ----Z变换---->
% Yz - b*(z^{-1}*Yz + y_neg1) = Xz
eq = Yz - b*(Yz/z + y_neg1) == Xz;

% 求解 Y(z)
Yz_sol = solve(eq, Yz);

% 逆 Z 变换得到完全响应 y(n)
y_expr = iztrans(Yz_sol, z, n);

% 化简结果
y = simplify(y_expr);

% 显示闭式解
disp('完全响应 y(n) = ');
disp(y);

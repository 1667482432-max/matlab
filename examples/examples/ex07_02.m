clear;
close all;
clc;


% ex07_02.m  |  例7.2 · 符号表示离散序列  |  AI 生成，已校验，R2023b
% 清空工作区，清屏
clear; clc;

% 定义符号变量 n
syms n integer

% 用 piecewise 定义离散单位阶跃序列 u(n)
% n >= 0 时为 1，否则为 0
u(n) = piecewise(n >= 0, 1, 0);

% 定义矩形序列 x(n) = u(n) - u(n-4)
x(n) = u(n) - u(n-4);

% 生成 n 的取值向量：从 -2 到 6 的整数
n_vals = -2:6;

% 计算 x(n) 在这些点上的值（x 是符号函数，可以直接代入向量）
x_vals = x(n_vals);

% 将结果整理成表格
T = table(n_vals(:), x_vals(:), 'VariableNames', {'n', 'x_n'});

% 显示表格
disp('矩形序列 x(n) = u(n) - u(n-4) 的取值表：');
disp(T);

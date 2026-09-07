clear;
close all;
clc;


% ex05_01.m  |  例5.1 · laplace 正变换  |  AI 生成，已校验，R2023b
% 符号方法求拉普拉斯变换
syms t s w                                     % 定义符号变量：时间 t，复频率 s，参数 w

% 定义时域函数
f1 = t^3;                                      % 函数1：t^3
f2 = sin(w*t);                                 % 函数2：sin(w*t)

% 计算拉普拉斯变换，结果存入 F1、F2
F1 = laplace(f1, t, s);                        % L{t^3}
F2 = laplace(f2, t, s);                        % L{sin(w*t)}

% 显示结果
disp('F1 = '), disp(F1)
disp('F2 = '), disp(F2)

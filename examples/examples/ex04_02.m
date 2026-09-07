clear;
close all;
clc;


% ex04_02.m  |  例4.2 · 符号法  |  AI 生成，已校验，R2023b
% 符号运算求傅里叶变换与逆变换
syms t w
% 定义单位阶跃函数 u(t)
u = heaviside(t);

% 1. 求 t*u(t) 的傅里叶变换
f1 = t * u;
F_tu = fourier(f1, t, w);
disp('t*u(t) 的傅里叶变换 F_tu(w):');
disp(F_tu);

% 2. 求 sin(t) 的傅里叶变换
f2 = sin(t);
F_sin = fourier(f2, t, w);
disp('sin(t) 的傅里叶变换 F_sin(w):');
disp(F_sin);

% 3. 求频域单位冲激 delta(w) 的傅里叶逆变换
f3_time = ifourier(dirac(w), w, t);
disp('delta(w) 的傅里叶逆变换 f3_time(t):');
disp(f3_time);

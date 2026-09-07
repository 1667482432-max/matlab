clear;
close all;
clc;


% ex08_01.m  |  例8.1 · z 正变换+逆变换  |  AI 生成，已校验，R2023b
% 符号z变换与逆z变换示例
% 兼容 MATLAB R2023b

syms n z
assume(n >= 0)          % 假设因果序列 n>=0，使逆变换结果更简洁

% 定义序列
x1 = (1/2)^n;
x2 = n * (n-1) / 2;

% 求z变换
X1 = ztrans(x1, n, z);
X2 = ztrans(x2, n, z);

% 显示z变换结果
disp('X1(z) = ')
disp(X1)

disp('X2(z) = ')
disp(X2)

% 求逆z变换
x1_inv = iztrans(X1, z, n);
x2_inv = iztrans(X2, z, n);

% 显示逆变换结果
disp('逆Z变换得到的 x1(n) = ')
disp(x1_inv)

disp('逆Z变换得到的 x2(n) = ')
disp(x2_inv)

clear;
close all;
clc;


% ex08_02.m  |  例8.2 · 逆 z 变换（部分分式法）  |  AI 生成，已校验，R2023b
clear; clc;

% 定义符号变量
syms z n

% 定义 X(z)
Xz = z^2 / (z^2 - 1.5*z + 0.5);

%% 方法一：直接使用 iztrans 求逆 z 变换
x_iz = iztrans(Xz, z, n);
disp('方法一：直接使用 iztrans 得到的 x(n) = ')
disp(x_iz)

%% 方法二：部分分式展开法
% 步骤1：计算 X(z)/z
Xz_over_z = Xz / z;

% 步骤2：对 X(z)/z 进行部分分式展开
Xz_over_z_part = partfrac(Xz_over_z, z, 'FactorMode', 'full');
disp('X(z)/z 的部分分式展开 = ')
disp(Xz_over_z_part)

% 步骤3：乘回 z，得到 X(z) 的部分分式形式
Xz_part = z * Xz_over_z_part;
disp('X(z) 的部分分式形式 = ')
disp(Xz_part)

% 步骤4：查表写出右边序列 x(n)
% 由部分分式可知项为 2*z/(z-1) 和 -z/(z-0.5)
% 查表得逆变换：2*(1)^n 和 -(0.5)^n ，收敛域 |z|>1
x_man = 2 - (1/2)^n;    % n>=0 的因果序列
disp('根据部分分式查表得到的 x(n) = ')
disp(x_man)

%% 比较两种方法在 n = 0:5 时的结果
n_vals = 0:5;
x_iz_vals = double(subs(x_iz, n, n_vals));  % 代入数值
x_man_vals = double(subs(x_man, n, n_vals));

% 显示比较结果
disp('  n          iztrans结果        部分分式法结果')
disp([n_vals' , x_iz_vals' , x_man_vals'])

% 计算最大绝对误差
err = max(abs(x_iz_vals - x_man_vals));
disp(['最大绝对误差 = ', num2str(err)]);

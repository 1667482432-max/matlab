clear;
close all;
clc;


% ex03_03.m  |  例3.3 · roots 齐次解  |  AI 生成，已校验，R2023b
% 齐次微分方程 r'''(t)+7r''(t)+16r'(t)+12r(t)=0
% 特征多项式系数：从最高阶到常数项
coeff = [1, 7, 16, 12];

% 求特征方程的根
rts = roots(coeff);

% 显示特征根
disp('特征根 rts =');
disp(rts);

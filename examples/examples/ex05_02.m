clear;
close all;
clc;


% ex05_02.m  |  例5.2 · partfrac 逆变换  |  AI 生成，已校验，R2023b
% 符号变量定义
syms s t

%% 1. F1(s) = 10*(s+2)*(s+5) / (s*(s+1)*(s+3))
F1 = 10*(s+2)*(s+5) / (s*(s+1)*(s+3));
F1_part = partfrac(F1);                    % 部分分式展开
f1 = ilaplace(F1_part, s, t);             % 拉普拉斯逆变换
disp('F1(s) 部分分式展开：');
disp(F1_part);
disp('→ f1(t) =');
disp(f1);

%% 2. F2(s) = (s^3 + 5*s^2 + 9*s + 7) / ((s+1)*(s+2))
F2 = (s^3 + 5*s^2 + 9*s + 7) / ((s+1)*(s+2));
F2_part = partfrac(F2);
f2 = ilaplace(F2_part, s, t);
disp('F2(s) 部分分式展开：');
disp(F2_part);
disp('→ f2(t) =');
disp(f2);

%% 3. F3(s) = (s^2 + 3) / ((s^2 + 2*s + 5)*(s+2))
F3 = (s^2 + 3) / ((s^2 + 2*s + 5)*(s+2));
F3_part = partfrac(F3);
f3 = ilaplace(F3_part, s, t);
disp('F3(s) 部分分式展开：');
disp(F3_part);
disp('→ f3(t) =');
disp(f3);

%% 4. F4(s) = (s-2) / (s*(s+1)^3)
F4 = (s-2) / (s*(s+1)^3);
F4_part = partfrac(F4);
f4 = ilaplace(F4_part, s, t);
disp('F4(s) 部分分式展开：');
disp(F4_part);
disp('→ f4(t) =');
disp(f4);

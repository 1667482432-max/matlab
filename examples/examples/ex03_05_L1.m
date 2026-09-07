clear;
close all;
clc;


% ex03_05_L1.m  |  例3.5 · L1 受控复现  |  AI 生成，已校验，R2023b
% 连续LTI系统零输入、零状态与完全响应
A = [-1 -1; 4 -6];
B = [1; 0];
C = [-1 0];
D = 1;
sys = ss(A, B, C, D);

% 1. 对输入2仿真到稳态，取末状态作为起始状态x0
t_steady = 0:0.01:10;
u_steady = 2 * ones(size(t_steady));
[~, ~, x_steady] = lsim(sys, u_steady, t_steady, [0; 0]);
x0 = x_steady(end, :)';

% 2. t>=0 求零输入、零状态与完全响应
t = 0:0.01:10;
u4 = 4 * ones(size(t));

% 零输入响应
[izi, t_izi] = initial(sys, x0, t);
% 零状态响应
[izs, t_izs] = lsim(sys, u4, t, [0; 0]);
% 完全响应
[ifull, t_ifull] = lsim(sys, u4, t, x0);

% 验证完全响应 = 零输入响应 + 零状态响应
max_err = max(abs(ifull - (izi + izs)));
fprintf('ifull与izi+izs的最大误差为: %.6e\n', max_err);

% 3. 对照：t从-10到10，输入在t<0为2、t>=0为4，零初始状态
t_all = -10:0.01:10;
u_all = 2 * (t_all < 0) + 4 * (t_all >= 0);
[ifull2, t_all_out] = lsim(sys, u_all, t_all, [0; 0]);

% 4. 绘图对比
figure;
plot(t_all_out, ifull2, 'Color', [0 0.5 0], 'LineWidth', 2); hold on;
plot(t_izi, izi, 'b-', 'LineWidth', 2);
plot(t_izs, izs, 'r--', 'LineWidth', 2);
plot(t_ifull, ifull, 'k:', 'LineWidth', 2);
hold off;
xlim([-10 10]);
grid on;
xlabel('时间 (s)', 'FontSize', 24);
ylabel('输出', 'FontSize', 24);
title('连续LTI系统响应对比', 'FontSize', 24);
legend('ifull2 (对照)', 'izi (零输入)', 'izs (零状态)', 'ifull (完全)', 'FontSize', 24);
set(gca, 'FontSize', 24);

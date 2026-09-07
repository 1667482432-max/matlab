clear;
close all;
clc;


% ex05_06.m  |  例5.6 · 傅里叶＝拉氏在虚轴  |  AI 生成，已校验，R2023b
% 拉普拉斯变换与傅里叶变换关系可视化
% 例1：矩形脉冲 x(t)=1 (0<=t<=T), X(s)=(1-exp(-sT))/s
% 例2：一阶系统 H(s)=1/(s+a), a>0
% 在s平面绘制|·|的三维曲面，并用粗红线标出虚轴切片（傅里叶变换）
% 各配二维子图验证切片与理论频谱/频率响应重合

clear; close all;

% ---------- 通用设置 ----------
set(0, 'DefaultAxesFontSize', 24);

%% 例1：矩形脉冲
T = 1;
% s平面网格，聚焦虚轴附近
sigma_vals = linspace(-3, 3, 101);
w_vals1 = linspace(-15, 15, 101);
[Sigma1, W1] = meshgrid(sigma_vals, w_vals1);
s1 = Sigma1 + 1i*W1;

% X(s) = (1 - exp(-sT))/s，处理s=0的可去奇点
Xs = (1 - exp(-s1*T)) ./ s1;
idx0 = abs(s1) < 1e-6;
if any(idx0(:))
    Xs(idx0) = T;   % 极限值
end
Z1 = abs(Xs);

% 限幅，使极值不淹没曲面细节
maxZ1 = 5;
Z1(Z1 > maxZ1) = maxZ1;

% ----- 三维曲面 -----
figure('Position', [100 100 900 700]);
subplot(2,1,1);
surf(Sigma1, W1, Z1, 'EdgeColor', 'none');
shading interp;
colormap(jet(256));
caxis([0 maxZ1]);               % 色彩从0到上限，凸显变化
colorbar;
xlabel('\sigma', 'FontSize', 24);
ylabel('j\omega', 'FontSize', 24);
zlabel('|X(s)|', 'FontSize', 24);
title('例1: 矩形脉冲的拉普拉斯变换幅度 |X(s)|', 'FontSize', 24);
grid on;
hold on;

% 提取虚轴切片，用粗红线叠画在曲面上
[~, idx_s0_1] = min(abs(sigma_vals - 0));
Z_slice1 = Z1(:, idx_s0_1);
plot3(zeros(size(w_vals1)), w_vals1, Z_slice1, 'r-', 'LineWidth', 3);

camlight left; lighting gouraud; material dull;
view(-30, 30);   % 视角保证红线可见
hold off;

% ----- 二维验证图 -----
subplot(2,1,2);
% 理论频谱 |X(jω)| = |sinc(ωT/2)| * T 的另一种形式
w_dense1 = linspace(-15, 15, 500);
Xjw_theory = (1 - exp(-1i*w_dense1*T)) ./ (1i*w_dense1);
Xjw_theory(abs(w_dense1) < 1e-6) = T;
plot(w_dense1, abs(Xjw_theory), 'b-', 'LineWidth', 2); hold on;
% 从三维切片提取的幅值
plot(w_vals1, Z_slice1, 'r--', 'LineWidth', 2);
hold off;
xlabel('\omega (rad/s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('虚轴切片与频谱 |X(j\omega)| 对比验证', 'FontSize', 24);
legend('理论 |X(j\omega)|', '切片 |X(0+j\omega)|', 'FontSize', 24);
grid on;

%% 例2：一阶系统 H(s) = 1/(s+a)
a = 1;
% s平面网格，包含极点 s=-a
sigma_vals2 = linspace(-3, 1, 101);   % 包含-1
w_vals2 = linspace(-10, 10, 101);
[Sigma2, W2] = meshgrid(sigma_vals2, w_vals2);
s2 = Sigma2 + 1i*W2;

Hs = 1 ./ (s2 + a);
Z2 = abs(Hs);

% 限幅
maxZ2 = 5;
Z2(Z2 > maxZ2) = maxZ2;

% ----- 三维曲面 -----
figure('Position', [100 100 900 700]);
subplot(2,1,1);
surf(Sigma2, W2, Z2, 'EdgeColor', 'none');
shading interp;
colormap(jet(256));
caxis([0 maxZ2]);
colorbar;
xlabel('\sigma', 'FontSize', 24);
ylabel('j\omega', 'FontSize', 24);
zlabel('|H(s)|', 'FontSize', 24);
title('例2: 一阶系统 H(s)=1/(s+a), a=1 的幅度 |H(s)|', 'FontSize', 24);
grid on;
hold on;

% 虚轴切片（傅里叶变换）
[~, idx_s0_2] = min(abs(sigma_vals2 - 0));
Z_slice2 = Z2(:, idx_s0_2);
plot3(zeros(size(w_vals2)), w_vals2, Z_slice2, 'r-', 'LineWidth', 3);

camlight left; lighting gouraud; material dull;
view(30, 30);    % 另一视角，清晰显示红线
hold off;

% ----- 二维验证图 -----
subplot(2,1,2);
% 理论频率响应 |H(jω)| = 1 / sqrt(ω^2 + a^2)
w_dense2 = linspace(-10, 10, 500);
Hjw_theory = 1 ./ abs(1i*w_dense2 + a);
plot(w_dense2, Hjw_theory, 'b-', 'LineWidth', 2); hold on;
plot(w_vals2, Z_slice2, 'r--', 'LineWidth', 2);
hold off;
xlabel('\omega (rad/s)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('虚轴切片与频率响应 |H(j\omega)| 对比验证', 'FontSize', 24);
legend('理论 |H(j\omega)|', '切片 |H(0+j\omega)|', 'FontSize', 24);
grid on;

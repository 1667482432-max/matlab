clear;
close all;
clc;


% ex08_07.m  |  例8.7 · 全通系统  |  AI 生成，已校验，R2023b
% 二阶离散系统分析：差分方程 y(n)-1.1y(n-1)+0.6y(n-2)=0.6x(n)-1.1x(n-1)+x(n-2)

clear; close all;

%% 1. 系统函数 H(z) 的系数与显示
b = [0.6, -1.1, 1];      % 分子系数（按 z^0, z^{-1}, z^{-2} 顺序）
a = [1, -1.1, 0.6];      % 分母系数
disp('系统函数 H(z) = (0.6 - 1.1z^{-1} + z^{-2}) / (1 - 1.1z^{-1} + 0.6z^{-2})')

%% 2. 零极点图
figure;
zplane(b, a);
title('零极点图');
% 设置字体与线宽
ax = gca; ax.FontSize = 24;
xlabel('实部'); ylabel('虚部');
% 调整零极点标记的大小/线宽
hLines = findobj(gca, 'Type', 'line');
set(hLines, 'LineWidth', 2);
hCircle = findobj(gca, 'Marker', 'o'); % 零点
set(hCircle, 'LineWidth', 2, 'MarkerSize', 10);
hCross = findobj(gca, 'Marker', 'x'); % 极点
set(hCross, 'LineWidth', 2, 'MarkerSize', 10);
grid on;

%% 3. 单位样值响应
n_imp = 0:30;
h_imp = impz(b, a, n_imp);
figure;
stem(n_imp, h_imp, 'b', 'LineWidth', 2, 'MarkerSize', 6);
xlabel('n'); ylabel('h(n)');
title('单位样值响应');
ax = gca; ax.FontSize = 24;
grid on;

%% 4. 幅频与相频特性
Nfft = 512;
[H, w] = freqz(b, a, Nfft, 'whole');
H_mag = abs(H);
H_phase = unwrap(angle(H));  % 解卷绕相位

figure('Position', [100, 100, 900, 700]); % 纵向两个子图，加高
subplot(2,1,1);
plot(w/pi, H_mag, 'b', 'LineWidth', 2);
xlabel('归一化频率 (\times\pi rad/sample)');
ylabel('幅度');
title('幅频特性');
ax = gca; ax.FontSize = 24;
grid on;

subplot(2,1,2);
plot(w/pi, H_phase, 'r', 'LineWidth', 2);
xlabel('归一化频率 (\times\pi rad/sample)');
ylabel('相位 (rad)');
title('相频特性');
ax = gca; ax.FontSize = 24;
grid on;

%% 5. 输入正弦序列与输出对比
n = 0:50;
f0 = 0.05;          % 数字频率 0.05*2pi -> 周期20点
x_sin = sin(2*pi*f0 * n);
y_sin = filter(b, a, x_sin);

figure;
plot(n, x_sin, 'b-', 'LineWidth', 2); hold on;
plot(n, y_sin, 'r--', 'LineWidth', 2); hold off;
xlabel('n'); ylabel('幅度');
title('正弦输入与输出');
legend('输入 x(n)', '输出 y(n)');
ax = gca; ax.FontSize = 24;
grid on;

%% 6. 输入方波序列与输出对比
% 生成周期为20的方波（与正弦同周期）
x_squa = square(2*pi*f0 * n);   % 幅度 ±1
y_squa = filter(b, a, x_squa);

figure;
plot(n, x_squa, 'b-', 'LineWidth', 2); hold on;
plot(n, y_squa, 'r--', 'LineWidth', 2); hold off;
xlabel('n'); ylabel('幅度');
title('方波输入与输出');
legend('输入 x(n)', '输出 y(n)');
ax = gca; ax.FontSize = 24;
grid on;

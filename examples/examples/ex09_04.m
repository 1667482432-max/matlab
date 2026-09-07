clear;
close all;
clc;


% ex09_04.m  |  例9.4 · 快速卷积  |  AI 生成，已校验，R2023b
% 定义序列
x = [1 2 3 4 5 6 7 8];
h = [1 1 1 1];

% 直接卷积
y_conv = conv(x, h);

% FFT 快速卷积
N = length(x) + length(h) - 1;   % 线性卷积长度
X = fft(x, N);
H = fft(h, N);
Y = X .* H;
y_fft = real(ifft(Y));           % 去除微小的虚部误差

% 计算并显示最大绝对误差
max_err = max(abs(y_fft - y_conv));
disp(['快速卷积与 conv 结果的最大绝对误差: ', num2str(max_err)]);

% 绘图对比
n = 0:N-1;                      % 序列索引（0 到 10）
figure;
stem(n, y_conv, 'b', 'LineWidth', 2);        % conv 结果：蓝色实线
hold on;
stem(n, y_fft, 'r--', 'LineWidth', 2);       % FFT 结果：红色虚线
xlabel('n');
ylabel('幅值');
title('线性卷积对比');
legend('conv', 'FFT快速卷积');
grid on;
set(gca, 'FontSize', 24);

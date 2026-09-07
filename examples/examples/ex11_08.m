clear;
close all;
clc;


% ex11_08.m  |  例11.8 · 单边带 SSB（hilbert 相移法）  |  AI 生成，已校验，R2023b
% 设置全局图形属性：字号24，后续绘图自动继承
set(groot, 'DefaultAxesFontSize', 24);

% --- 1. 由 prefourier 生成计算所需时频网格与变换矩阵 ---
Trg   = [0, 2*pi];          % 时间观测区间
N     = 2048;              % 时间采样点数
OMGrg = [-150, 150];       % 频率显示范围 (rad/s)
K     = 2048;              % 频率采样点数

[t, omg, FT, IFT] = prefourier(Trg, N, OMGrg, K);

% --- 2. 构造基带信号 g(t) 及其希尔伯特变换 ghat(t) ---
g    = 3*cos(10*t) + 2*cos(20*t);      % 基带信号 (列向量)
ghat = imag(hilbert(g));               % 希尔伯特变换

% --- 3. 载波与 SSB（上边带）调制，同时生成 DSB 用于对比 ---
c = cos(100*t);                        % 载波
s = g.*c - ghat.*sin(100*t);           % 上边带信号
d = g.*c;                              % 双边带 (DSB) 信号

% --- 4. 计算频谱 ---
G = FT * g;                            % 基带频谱
S = FT * s;                            % SSB 频谱
D = FT * d;                            % DSB 频谱

% --- 5. 频谱对比绘图 ---
figure('Position', [100, 100, 900, 700]);   % 加高以适应两个子图

subplot(2,1,1);
plot(omg, abs(G), 'b', 'LineWidth', 2);
grid on;
xlabel('\omega (rad/s)');
ylabel('幅度');
title('基带信号 g(t) 的频谱');
% 单曲线，不加图例

subplot(2,1,2);
plot(omg, abs(S), 'r', 'LineWidth', 2);  hold on;
plot(omg, abs(D), 'k--', 'LineWidth', 2); hold off;
grid on;
xlabel('\omega (rad/s)');
ylabel('幅度');
title('SSB 与 DSB 频谱对比');
legend('SSB (上边带)', 'DSB (双边带)', 'Location', 'best');

% --- 6. 相干解调并理想低通恢复基带 ---
r = s .* cos(100*t);                    % 乘以本地载波

wc = 30;                                % 低通截止频率 (rad/s)
H  = double(abs(omg) <= wc);            % 理想低通频域响应
R  = FT * r;                            % 接收信号频谱
R_filt = R .* H;                        % 低通滤波
gr = IFT * R_filt;                      % 傅里叶反变换回时域
gr = 2 * real(gr);                      % 幅度补偿

% --- 7. 恢复信号与原始基带对比 ---
figure;
plot(t, g,  'b', 'LineWidth', 2);  hold on;
plot(t, gr, 'r--', 'LineWidth', 2); hold off;
grid on;
xlabel('t (s)');
ylabel('幅度');
title('相干解调恢复基带与原始信号对比');
legend('原始 g(t)', '恢复 g_r(t)', 'Location', 'best');

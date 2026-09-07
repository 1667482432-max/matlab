clear;
close all;
clc;


% ex12_05.m  |  例12.5 · 脉冲成形（矩形／升余弦／Sa 脉冲）  |  AI 生成，已校验，R2023b
% 比较数字传输中三种脉冲（矩形、升余弦、Sa）的波形与频谱，
% 并展示以它们承载随机数据的信息波形及频谱。

clear; close all;

%% 参数设置
Fs = 1000;              % 采样频率 (Hz)
Ts = 1;                 % 符号/比特宽度 (s), 矩形脉冲宽度, 升余弦的符号周期
alpha = 0.5;            % 升余弦滚降系数
t_pulse = -2:1/Fs:2;    % 单脉冲时域显示范围
f_max_view = 4/Ts;      % 频谱显示上限 (Hz)

%% ========== (一) 单脉冲波形与频谱 ==========
% ---------- 构造三个脉冲 ----------
% 矩形脉冲: 宽度 Ts, 高度 1
rect_pulse = double(abs(t_pulse) < Ts/2);

% 升余弦脉冲 (raised cosine): 时域公式
rc_pulse = rc_time(t_pulse, Ts, alpha);

% Sa脉冲: 用 sinc(2*t/Ts) 使其主瓣宽度与矩形脉冲相近
sa_pulse = sinc(2 * t_pulse / Ts);

% ---------- 绘制时域波形 ----------
figure('Position',[100 100 900 700]);   % 加高画布，容纳两个子图
subplot(2,1,1);
plot(t_pulse, rect_pulse, 'b-', ...
     t_pulse, rc_pulse, 'r--', ...
     t_pulse, sa_pulse, 'k:', 'LineWidth',2);
grid on;
set(gca, 'FontSize',24);
xlabel('时间 (s)', 'FontSize',24);
ylabel('幅度', 'FontSize',24);
title('三种脉冲时域波形', 'FontSize',24);
legend('矩形脉冲', '升余弦脉冲', 'Sa脉冲', 'FontSize',20, 'Location','best');

% ---------- 计算频谱 (单边幅度谱) ----------
N1 = length(t_pulse);
Y_rect = fft(rect_pulse);
Y_rc   = fft(rc_pulse);
Y_sa   = fft(sa_pulse);

% 频率轴
if mod(N1,2)==0
    Nhalf = N1/2;
else
    Nhalf = (N1-1)/2;
end
f_axis = Fs * (0:Nhalf) / N1;      % 正频率部分

% 取单边幅度谱（除直流外乘以2）
P_rect = abs(Y_rect(1:Nhalf+1)) / N1;
P_rect(2:end-1) = 2 * P_rect(2:end-1);

P_rc = abs(Y_rc(1:Nhalf+1)) / N1;
P_rc(2:end-1) = 2 * P_rc(2:end-1);

P_sa = abs(Y_sa(1:Nhalf+1)) / N1;
P_sa(2:end-1) = 2 * P_sa(2:end-1);

% 截取到显示频率上限
idx_f = f_axis <= f_max_view;

subplot(2,1,2);
plot(f_axis(idx_f), P_rect(idx_f), 'b-', ...
     f_axis(idx_f), P_rc(idx_f), 'r--', ...
     f_axis(idx_f), P_sa(idx_f), 'k:', 'LineWidth',2);
grid on;
set(gca, 'FontSize',24);
xlabel('频率 (Hz)', 'FontSize',24);
ylabel('幅度', 'FontSize',24);
title('三种脉冲幅度谱', 'FontSize',24);
legend('矩形脉冲', '升余弦脉冲', 'Sa脉冲', 'FontSize',20, 'Location','best');

%% ========== (二) 随机数据信息波形与频谱 ==========
Nbits = 20;                 % 随机比特数
bits = randi([0 1], 1, Nbits);
symbols = 2*bits - 1;       % 映射为 +1 (1) 和 -1 (0)
Tb = Ts;                    % 比特间隔等于脉冲宽度
Trunc = 3;                  % 脉冲截断范围 (s) , 保证衰减足够

% 总时间轴 (包含两端脉冲展宽)
t_total = -Trunc : 1/Fs : (Nbits-1)*Tb + Trunc;

% 定义脉冲函数
rect_func = @(t) double(abs(t) <= Tb/2);
rc_func   = @(t) rc_time(t, Tb, alpha);
sa_func   = @(t) sinc(2 * t / Tb);

% 生成三种信息波形
sig_rect = zeros(size(t_total));
sig_rc   = zeros(size(t_total));
sig_sa   = zeros(size(t_total));
for n = 1:Nbits
    shift = (n-1)*Tb;
    sig_rect = sig_rect + symbols(n) * rect_func(t_total - shift);
    sig_rc   = sig_rc   + symbols(n) * rc_func(t_total - shift);
    sig_sa   = sig_sa   + symbols(n) * sa_func(t_total - shift);
end

% 选择“升余弦脉冲”所成的信息波形的一段进行展示
t_view_range = t_total >= 0 & t_total <= 5*Tb;   % 显示前5个比特时长
t_view = t_total(t_view_range);
sig_view = sig_rc(t_view_range);

figure('Position',[100 100 900 700]);  % 加高画布
subplot(2,1,1);
plot(t_view, sig_view, 'r-', 'LineWidth',2);
grid on;
set(gca, 'FontSize',24);
xlabel('时间 (s)', 'FontSize',24);
ylabel('幅度', 'FontSize',24);
title('升余弦脉冲构成的一段信息波形', 'FontSize',24);
% 单曲线图不加 legend

% ---------- 三个信息波形的幅度谱 ----------
N_total = length(t_total);
Y_info_rect = fft(sig_rect);
Y_info_rc   = fft(sig_rc);
Y_info_sa   = fft(sig_sa);

if mod(N_total,2)==0
    Nhalf2 = N_total/2;
else
    Nhalf2 = (N_total-1)/2;
end
f_axis2 = Fs * (0:Nhalf2) / N_total;

P_info_rect = abs(Y_info_rect(1:Nhalf2+1)) / N_total;
P_info_rect(2:end-1) = 2 * P_info_rect(2:end-1);

P_info_rc = abs(Y_info_rc(1:Nhalf2+1)) / N_total;
P_info_rc(2:end-1) = 2 * P_info_rc(2:end-1);

P_info_sa = abs(Y_info_sa(1:Nhalf2+1)) / N_total;
P_info_sa(2:end-1) = 2 * P_info_sa(2:end-1);

idx_f2 = f_axis2 <= f_max_view;

subplot(2,1,2);
plot(f_axis2(idx_f2), P_info_rect(idx_f2), 'b-', ...
     f_axis2(idx_f2), P_info_rc(idx_f2), 'r--', ...
     f_axis2(idx_f2), P_info_sa(idx_f2), 'k:', 'LineWidth',2);
grid on;
set(gca, 'FontSize',24);
xlabel('频率 (Hz)', 'FontSize',24);
ylabel('幅度', 'FontSize',24);
title('三种脉冲信息波形的幅度谱', 'FontSize',24);
legend('矩形脉冲信息波', '升余弦脉冲信息波', 'Sa脉冲信息波', 'FontSize',20, 'Location','best');

%% ========== 局部函数：升余弦脉冲时域公式 ==========
function h = rc_time(t, T, alpha)
% 升余弦滤波器时域冲激响应
    h = zeros(size(t));
    for i = 1:length(t)
        ti = t(i);
        if abs(ti) < 1e-12
            h(i) = 1;                                  % t=0 极限
        elseif abs( abs(ti) - T/(2*alpha) ) < 1e-12
            h(i) = (pi/4) * sinc(1/(2*alpha));         % 分母为零点的极限
        else
            h(i) = sinc(ti/T) * cos(pi*alpha*ti/T) / (1 - (2*alpha*ti/T)^2);
        end
    end
end

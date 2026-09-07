clear;
close all;
clc;


% ex04_06.m  |  例4.6 · 语音·听四性质  |  AI 生成，已校验，R2023b
% 读取语音信号
[x, Fs] = audioread('ssisinteresting.wav');   % x 可能是双声道，只取第一个声道
if size(x,2) > 1
    x = x(:,1);
end
x = double(x);                % 确保为双精度浮点
N = length(x);
t = (0:N-1)' / Fs;            % 时间轴

% ---- 1. 尺度变换 ----
disp('--- 傅里叶性质 1：尺度变换 ---')
disp('原始语音')
soundsc(x, Fs);               % 播放原始语音
pause(N/Fs + 1);              % 等待播放结束

disp('播放 x(1.5t)')
soundsc(x, Fs*1.5);           % 改变采样率实现时间压缩
pause(N/(Fs*1.5) + 1);

disp('播放 x(0.7t)')
soundsc(x, Fs*0.7);           % 改变采样率实现时间拉伸
pause(N/(Fs*0.7) + 1);

% ---- 2. 频移（调制） ----
disp('--- 傅里叶性质 2：频移 ---')
disp('原始语音')
soundsc(x, Fs);
pause(N/Fs + 1);

x_mod = x .* cos(2*pi*1000*t);   % 乘以 cos(2pi*1000*t) 实现频谱搬移
disp('乘以 cos(2*pi*1000*t) 后')
soundsc(x_mod, Fs);
pause(N/Fs + 1);

% ---- 3. 时域微分 ----
disp('--- 傅里叶性质 3：时域微分 ---')
disp('原始语音')
soundsc(x, Fs);
pause(N/Fs + 1);

dx = gradient(x, 1/Fs);           % 数值微分（保持长度）
disp('时域微分后')
soundsc(dx, Fs);
pause(N/Fs + 1);

% ---- 4. 时域积分 ----
disp('--- 傅里叶性质 4：时域积分 ---')
disp('原始语音')
soundsc(x, Fs);
pause(N/Fs + 1);

x_demean = x - mean(x);           % 去掉直流，避免积分后线性漂移
x_int = cumtrapz(t, x_demean);    % 累积积分
disp('时域积分后')
soundsc(x_int, Fs);
pause(N/Fs + 1);

disp('全部演示结束。')

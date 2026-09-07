clear;
close all;
clc;


% ex06_02_L2.m  |  例6.2 · 消啪声（L2）  |  AI 生成，已校验，R2023b
% 《东方红》开头四小节音乐合成 —— 带包络消除衔接杂声
% 兼容 MATLAB R2023b，用幅度 1、采样率 8000 Hz 的正弦波合成、拼接，并加入淡入淡出包络
% 同时对比原始拼接与包络处理后信号的衔接点波形和幅度

clear; clc; close all;

%% 1. 参数设置
Fs = 8000;                    % 采样率 (Hz)
A = 1;                        % 信号幅度
beat_duration = 0.5;          % 一拍时长 (秒)，2/4 拍，一拍约 0.5 秒

% 十二平均律基准：A4 = 440 Hz
A4 = 440;

% 计算 F 大调各中音音阶对应的频率（按题目给出的映射关系）
% 中音 1 2 3 4 5 6 7 = F4 G4 A4 Bb4 C5 D5 E5
F4  = A4 * 2^(-4/12);   % F4 比 A4 低 4 个半音
G4  = A4 * 2^(-2/12);   % G4 比 A4 低 2 个半音
A4_note = A4;            % A4 就是 440 Hz
Bb4 = A4 * 2^(-1/12);   % Bb4 比 A4 低 1 个半音
C5  = A4 * 2^(3/12);    % C5 比 A4 高 3 个半音
D5  = A4 * 2^(5/12);    % D5 比 A4 高 5 个半音
E5  = A4 * 2^(7/12);    % E5 比 A4 高 7 个半音
D4  = A4 * 2^(-7/12);   % D4 比 A4 低 7 个半音（即 D5 低一个八度）

%% 2. 定义音符序列及其时值
% 简谱顺序：5 5 6 2 1 1 低6 2
% 对应音名：C5 C5 D5 G4 F4 F4 D4 G4
notes = [C5, C5, D5, G4, F4, F4, D4, G4];
% 对应节拍比例：一拍(1) 半拍(0.5) 半拍(0.5) 两拍(2) 一拍(1) 半拍(0.5) 半拍(0.5) 两拍(2)
durations = beat_duration * [1, 0.5, 0.5, 2, 1, 0.5, 0.5, 2];

% 将频率存入指定变量
freqs = notes;   % 各音频率 (Hz)

%% 3. 原始直接拼接合成（无包络）
y = [];                     % 初始化原始输出信号
for k = 1:length(notes)
    f = notes(k);           % 当前音符频率
    dur = durations(k);     % 当前音符时长
    n_samples = round(dur * Fs);   % 当前音符的采样点数
    t_seg = (0:n_samples-1) / Fs;  % 当前音符的时间轴
    segment = A * sin(2 * pi * f * t_seg);
    y = [y, segment];       % 直接拼接
end
t = (0:length(y)-1) / Fs;   % 总时间向量

%% 4. 带包络拼接合成，消除衔接杂声
% 方法：为每个音符的信号段乘上一个两端渐变为零的包络（线性淡入淡出）。
% 淡入淡出时长取 0.01 秒（80 个采样点），使相邻音符在衔接点幅度均为 0，
% 从而消除因幅度突变引起的“啪”声。
ramp_len = round(0.01 * Fs);   % 淡入淡出段长度（样本数）

y2 = [];                    % 初始化带包络的输出信号
for k = 1:length(notes)
    f = notes(k);
    dur = durations(k);
    n_samples = round(dur * Fs);
    t_seg = (0:n_samples-1) / Fs;
    segment_raw = A * sin(2 * pi * f * t_seg);
    
    % 构造两端渐变到零的包络窗 w
    % 原则：音符足够长时，中间保持幅度 1，前后用线性斜坡连接 0 和 1；
    %        音符过短时，整个窗就是一个三角形（从 0 到中间 1 再回到 0）。
    if n_samples >= 2 * ramp_len
        w = ones(1, n_samples);
        w(1:ramp_len) = linspace(0, 1, ramp_len);                 % 淡入
        w(end - ramp_len + 1 : end) = linspace(1, 0, ramp_len);   % 淡出
    else
        % 音符太短，无法包含完整的斜坡+平坦区，直接使用一个三角窗
        mid = ceil(n_samples/2);
        w = [linspace(0, 1, mid), linspace(1, 0, n_samples - mid)];
    end
    
    segment_env = segment_raw .* w;   % 加包络
    y2 = [y2, segment_env];           % 拼接
end

%% 5. 播放两种合成结果并打印频率
fprintf('《东方红》开头四小节各音频率 (Hz):\n');
fprintf('音符 5  (C5): %.2f Hz\n', C5);
fprintf('音符 6  (D5): %.2f Hz\n', D5);
fprintf('音符 2  (G4): %.2f Hz\n', G4);
fprintf('音符 1  (F4): %.2f Hz\n', F4);
fprintf('音符 低6(D4): %.2f Hz\n', D4);
fprintf('\n按序列打印:\n');
for k = 1:length(notes)
    fprintf('第%d个音: %.2f Hz, 时长 %.2f s\n', k, notes(k), durations(k));
end

fprintf('\n播放原始直接拼接信号 y ...\n');
sound(y, Fs);
pause(sum(durations) + 0.5);   % 等待播放完毕再播下一个

fprintf('播放带包络信号 y2 ...\n');
sound(y2, Fs);

%% 6. 绘制原始波形与包络处理波形局部对比，聚焦第一个衔接点
% 衔接点位于第一个音符结束、第二个音符开始处，时间 t_trans = durations(1)
trans_time = durations(1);                     % 第一个音符时长
idx_trans = round(trans_time * Fs);            % 衔接点对应的样本索引（第一个音符的最后一个样本）

% 截取衔接点附近一小段用于对比，前后各取 0.05 秒（若边界不够则自适应）
half_len = round(0.05 * Fs);
start_idx = max(1, idx_trans - half_len);
end_idx = min(length(y), idx_trans + half_len);
idx_range = start_idx:end_idx;
t_zoom = t(idx_range);
y_zoom = y(idx_range);
y2_zoom = y2(idx_range);

% 打印衔接点处的幅度（索引 idx_trans 对应 y 的结尾，idx_trans+1 对应 y 的开头）
fprintf('\n衔接点 (t ≈ %.3f s) 附近幅度对比:\n', trans_time);
fprintf('原始拼接 y :  结尾幅度 = %.4f,  开头幅度 = %.4f\n', y(idx_trans), y(idx_trans+1));
fprintf('包络处理 y2:  结尾幅度 = %.4f,  开头幅度 = %.4f\n', y2(idx_trans), y2(idx_trans+1));
fprintf('两者在衔接处的幅度差: 原始 = %.4f, 包络后 = %.4f\n', ...
    abs(y(idx_trans) - y(idx_trans+1)), abs(y2(idx_trans) - y2(idx_trans+1)));

% 上下对照画图：上图 y，下图 y2，纵向两个子图
figure('Position', [100 100 900 700]);   % 双子图，增加高度避免过扁
subplot(2,1,1);
plot(t_zoom, y_zoom, 'b-', 'LineWidth', 2);   % 蓝色实线
hold on;
xline(trans_time, 'r--', 'LineWidth', 2);     % 红色虚线标记衔接点
hold off;
grid on;
set(gca, 'FontSize', 24);
xlabel('时间 (秒)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('原始直接拼接 (y) — 衔接点附近波形', 'FontSize', 24);
% 单曲线子图不加图例

subplot(2,1,2);
plot(t_zoom, y2_zoom, 'r-', 'LineWidth', 2);  % 红色实线，区分明显
hold on;
xline(trans_time, 'r--', 'LineWidth', 2);
hold off;
grid on;
set(gca, 'FontSize', 24);
xlabel('时间 (秒)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
title('带淡入淡出包络 (y2) — 衔接点附近波形', 'FontSize', 24);
% 同样不加图例

%% 7. （可选）画出全曲波形对比，但这里不再额外绘制，以免图过多

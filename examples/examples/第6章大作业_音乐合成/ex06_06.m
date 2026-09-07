clear;
close all;
clc;


% ex06_06.m  |  例6.6 · 周期去噪  |  AI 生成，已校验，R2023b
clear; close all;

% 加载吉他单音信号，采样率 8000 Hz
load('Guitar.MAT', 'realwave');      % realwave 为原始波形
Fs = 8000;                           % 已知采样率

%% 1. 去直流，避免影响自相关与峰值检测
x = realwave(:);                     % 强制列向量
x = x - mean(x);                     % 消除直流偏置

%% 2. 用自相关函数估计基音周期
% 原理：周期信号的自相关函数在延迟等于基音周期时会出现极大值
% 找出除去零延迟外，在合理周期范围内第一个显著峰值对应的延迟量
[r, lags] = xcorr(x, 'biased');      % 有偏自相关，衰减更快但峰值位置准确
idx_pos = lags >= 0;                 % 只取非负延迟部分
r_pos = r(idx_pos);
lags_pos = lags(idx_pos);

% 设置合理的周期搜索范围（对应基频 40 Hz ~ 400 Hz）
min_period = 20;                     % 8000/400 = 20 样点
max_period = 200;                    % 8000/40  = 200 样点
idx_valid = (lags_pos > 0) & (lags_pos >= min_period) & (lags_pos <= max_period);
r_valid = r_pos(idx_valid);
lags_valid = lags_pos(idx_valid);

[~, i_max] = max(r_valid);           % 找最大自相关系数对应的延迟
T = lags_valid(i_max);               % T 即为估计的基音周期（样点数）
fprintf('估计的基音周期 = %d 样点\n', T);

%% 3. 提取所有局部极大值点（正向峰值），用于周期对齐
dx = diff(x);
% 找到由正变负的位置 → 局部极大值
peak_loc = find(diff(sign(dx)) < 0) + 1;  
% 排除幅值过小的噪声峰（阈值设为最大振幅的 20%）
thr = 0.2 * max(abs(x));
peak_loc = peak_loc(x(peak_loc) > thr);

if isempty(peak_loc)
    error('未检测到有效峰值，请检查输入信号或阈值。');
end

%% 4. 依据估计周期 T，构建与周期一致的峰值序列（用于对齐）
% 方法：从第一个峰值出发，在距离约 T 的位置寻找最近的峰值，形成一条时间链
p_chain = peak_loc(1);               % 初始化峰值链
p_current = peak_loc(1);
search_tol = round(0.3 * T);         % 搜索容差

for k = 1:length(peak_loc)
    % 在 p_current + T 附近寻找候选峰值
    target = p_current + T;
    cand = peak_loc(peak_loc >= target - search_tol & peak_loc <= target + search_tol);
    if isempty(cand)
        break;                       % 找不到下一周期对齐点，终止
    end
    % 选择距离目标最近的峰值
    [~, idx] = min(abs(cand - target));
    p_next = cand(idx);
    p_chain = [p_chain; p_next];    %#ok<AGROW>
    p_current = p_next;
end

if length(p_chain) < 2
    warning('对齐周期数少于2，改用简单的均匀分割方式进行平均。');
    % 后备方案：直接按周期 T 分割，从第一个样本开始
    num_periods = floor(length(x)/T);
    seg_matrix = reshape(x(1:num_periods*T), T, num_periods);
else
    %% 5. 以各峰值对齐，截取长度为 T 的周期片段
    pre = round(T/3);                % 峰值之前的样点数（使峰值落在周期内约1/3处）
    post = T - pre - 1;              % 峰值之后的样点数（总长 = pre + 1 + post = T）
    
    valid_peaks = [];
    for i = 1:length(p_chain)
        p = p_chain(i);
        if (p - pre >= 1) && (p + post <= length(x))
            valid_peaks(end+1) = p;  %#ok<AGROW>
        end
    end
    n = length(valid_peaks);
    seg_matrix = zeros(T, n);
    for i = 1:n
        p = valid_peaks(i);
        seg_matrix(:, i) = x(p - pre : p + post);
    end
end

%% 6. 对齐平均，得到干净的单周期波形
wave_clean = mean(seg_matrix, 2);    % 沿周期方向取平均

% 挑选一个具有代表性的原始单周期，用于后续与平均波形对比
% 选择幅值最大的那个峰值对应的片段（能量较高，信噪比相对好）
[~, best_idx] = max(abs(x(valid_peaks))); 
best_period = seg_matrix(:, best_idx);

%% 7. 绘图对比：原始完整波形 + 单周期对比（原始 vs 平均）
figure('Position', [100, 100, 900, 700]);  % 画布加高以容纳两个子图

% ---- 子图1：原始波形 ----
subplot(2,1,1);
plot(realwave, 'b', 'LineWidth', 2);
title('原始吉他单音波形', 'FontSize', 24);
xlabel('样本点', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
grid on;
set(gca, 'FontSize', 24);

% ---- 子图2：单周期对比 ----
subplot(2,1,2);
t_cycle = (0:T-1);                   % 一个周期内的样本索引
plot(t_cycle, best_period, 'b--', 'LineWidth', 2);  % 原始的一个周期
hold on;
plot(t_cycle, wave_clean, 'r-', 'LineWidth', 2);   % 平均后的干净周期
hold off;
legend('原始单周期', '平均干净周期', 'FontSize', 24, 'Location', 'best');
title(sprintf('单周期对比 (基音周期 = %d 样点)', T), 'FontSize', 24);
xlabel('样本点 (一个周期内)', 'FontSize', 24);
ylabel('幅度', 'FontSize', 24);
grid on;
set(gca, 'FontSize', 24);

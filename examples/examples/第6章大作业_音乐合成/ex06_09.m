clear;
close all;
clc;


% ex06_09.m  |  例6.9 · 自动检测音调节拍  |  AI 生成，已校验，R2023b
% =========================================================================
% 乐曲自动分段与音高识别脚本
% 输入：fmt.wav（8000 Hz，吉他演奏，先后奏多个单音）
% 输出：notes (cell, 音名), onsets (s), durations (s)
% 展示：波形图 + 音符分段彩色标注 + 命令行表格
% 方法：短时能量包络检测音符起止，自相关法估计基频，
%        十二平均律换算为钢琴音名（如 C4, E4）
% 兼容：MATLAB R2023b，不使用任何工具箱专有函数
% =========================================================================

clear; close all;

%% 1. 读取音频
[x, fs] = audioread('fmt.wav');
if fs ~= 8000
    warning('采样率不是 8000 Hz，脚本仍按 8000 处理，结果可能不准。');
end
% 确保为单声道列向量
if size(x,2) > 1
    x = mean(x,2);   % 左右声道平均
end
x = x(:);            % 转为列向量
Ntotal = length(x);

%% 2. 音符分割：基于短时能量包络检测
frameLen = 256;      % 帧长（约32 ms）
hopLen   = 128;      % 帧移（约16 ms）
energy = [];
% 计算短时能量（每帧平方和）
for i = 1 : hopLen : Ntotal-frameLen+1
    seg = x(i : i+frameLen-1);
    energy(end+1) = sum(seg.^2);
end
% 能量平滑：移动平均，消除微小抖动
M = 5;
energySmooth = filter(ones(1,M)/M, 1, energy);
% 自适应阈值：取平滑能量最大值的 10%
thr = 0.10 * max(energySmooth);
% 活动标志（高于阈值视为有音）
active = energySmooth > thr;

% 寻找上升沿和下降沿：从活动标志跳变点获得音符起止帧序号
onsetFrames  = [];  % 起始帧索引
offsetFrames = [];  % 结束帧索引
if active(1)
    onsetFrames = 1;
end
for k = 2:length(active)
    if active(k) && ~active(k-1)
        onsetFrames(end+1) = k;
    elseif ~active(k) && active(k-1)
        offsetFrames(end+1) = k-1;
    end
end
if active(end)
    offsetFrames(end+1) = length(active);
end
% 若未检测到任何音符，直接退出
if isempty(onsetFrames)
    disp('未检测到音符，程序结束。');
    return;
end

% 融合过短的间隔：若两音符间沉默短于 minSilence 秒，则合并为一个音符
minSilence = 0.05;  % 50 ms
minSilenceFrames = round(minSilence * fs / hopLen);
mergedOnsets = []; mergedOffsets = [];
currOnset = onsetFrames(1);
for i = 1:length(onsetFrames)
    if i < length(onsetFrames)
        gap = onsetFrames(i+1) - offsetFrames(i);
        if gap <= minSilenceFrames
            % 合并：不结束当前音符，继续等待下一个下降沿
            continue;
        end
    end
    % 当前音符结束
    mergedOnsets(end+1) = currOnset;
    mergedOffsets(end+1) = offsetFrames(i);
    if i < length(onsetFrames)
        currOnset = onsetFrames(i+1);
    end
end

% 剔除过短的音符（时长小于 20 ms）
minDur = 0.02;
minDurFrames = round(minDur * fs / hopLen);
valid = (mergedOffsets - mergedOnsets) >= minDurFrames;
mergedOnsets  = mergedOnsets(valid);
mergedOffsets = mergedOffsets(valid);

% 将帧序号转换为时间（秒）
onsetTimes  = (mergedOnsets-1)  * hopLen / fs;
offsetTimes = (mergedOffsets-1) * hopLen / fs;
% 防止结束时间超限
offsetTimes = min(offsetTimes, Ntotal/fs);
numNotes = length(onsetTimes);

%% 3. 基频估计（自相关法）与音名转换
notes = cell(numNotes,1);
f0s   = zeros(numNotes,1);
for n = 1:numNotes
    % 提取当前音符的样本区间
    startIdx = round(onsetTimes(n)*fs) + 1;
    endIdx   = round(offsetTimes(n)*fs);
    if endIdx <= startIdx, endIdx = startIdx; end
    startIdx = max(startIdx, 1);
    endIdx   = min(endIdx, Ntotal);
    seg = x(startIdx:endIdx);
    
    % 去均值、加汉明窗，减弱截断效应
    seg = seg - mean(seg);
    win = hamming(length(seg));
    seg = seg .* win;
    
    % 基频估计：自相关函数（无工具箱，手工计算循环实现）
    L = length(seg);
    r = zeros(L,1);
    for k = 0:L-1  % k 为延迟
        r(k+1) = sum( seg(1:L-k) .* seg(1+k:L) ) / L;  % 有偏估计
    end
    % 寻找自相关函数的显著峰值（对应基音周期）
    minF0 = 70;   % 吉他基频下限，略低于吉他最低弦 E2≈82 Hz
    maxF0 = 1000; % 上限，吉他高音泛音一般不超过此范围
    minLag = round(fs/maxF0);
    maxLag = round(fs/minF0);
    minLag = max(2, minLag);          % 至少避开零延迟点
    maxLag = min(L-1, maxLag);
    if minLag > maxLag
        f0s(n) = NaN;
        notes{n} = '?';
        continue;
    end
    % 在有效延迟范围内找最大值位置
    [peakVal, idx] = max(r(minLag+1 : maxLag+1));
    lag = idx + minLag - 1;  % 转为绝对延迟样本数
    % 检验峰值是否足够显著（大于自相关最大值的 0.3 倍）
    if peakVal < 0.3 * max(r)
        f0s(n) = NaN;
        notes{n} = '?';
        continue;
    end
    f0 = fs / lag;  % 基频
    f0s(n) = f0;
    
    % 基频转换为钢琴音名（十二平均律，A4=440 Hz）
    notes{n} = freq2note(f0);
end

% 输出变量
onsets = onsetTimes(:);
durations = (offsetTimes - onsetTimes).';
durations = durations(:);
notes = notes(:);

%% 4. 绘图：波形图 + 音符分段彩色标注
figure('Position',[100 100 1200 500]);
t = (0:Ntotal-1) / fs;
plot(t, x, 'k', 'LineWidth', 2); hold on;
xlabel('时间 (s)'); ylabel('幅值');
title(sprintf('波形与音符分段 （共 %d 个音）', numNotes));
grid on; set(gca,'FontSize',24);
yl = ylim; xl = xlim;
% 定义一组高对比颜色用于分段填充
colors = [ ...
    0.0 0.0 1.0;   % 蓝
    1.0 0.0 0.0;   % 红
    0.0 0.5 0.0;   % 深绿
    0.8 0.0 0.8;   % 紫
    0.0 0.8 0.8;   % 青
    0.8 0.5 0.0;   % 橙
    0.5 0.5 0.5];  % 灰
nColors = size(colors,1);
% 绘制每个音符分段矩形区域和音名文本
for n = 1:numNotes
    xPatch = [onsets(n), onsets(n)+durations(n), onsets(n)+durations(n), onsets(n)];
    yPatch = [yl(1), yl(1), yl(2), yl(2)];
    col = colors(mod(n-1, nColors)+1, :);
    patch(xPatch, yPatch, col, 'FaceAlpha', 0.15, 'EdgeColor', 'none');
    % 标注音名在区域中央偏上位置
    text(onsets(n) + durations(n)/2, yl(2)*0.9, notes{n}, ...
        'HorizontalAlignment','center', 'FontSize',24, ...
        'Color', col, 'FontWeight','bold');
end
hold off;

%% 5. 打印音符信息表格
fprintf('\n===== 音符分析结果 =====\n');
fprintf('%-4s %-6s %-12s %-12s %-10s\n', '序号', '音名', '起始(s)', '结束(s)', '基频(Hz)');
for n = 1:numNotes
    fprintf('%-4d %-6s %-12.3f %-12.3f %-10.2f\n', ...
        n, notes{n}, onsets(n), onsets(n)+durations(n), f0s(n));
end

% =========================================================================
% 子函数：基频 -> 钢琴音名（十二平均律，A4 = 440 Hz）
% =========================================================================
function noteStr = freq2note(f)
    if isnan(f) || f <= 0
        noteStr = '?'; return;
    end
    % 计算 MIDI 音符编号（四舍五入到最接近的半音）
    midi = round(12 * log2(f/440) + 69);
    if midi < 0 || midi > 127
        noteStr = '?';
        return;
    end
    % 八度确定：MIDI 0~11 为八度 -1，12~23 为八度0，..., 60~71 为八度4
    octave = floor(midi/12) - 1;
    % 音名数组（从 C 开始）
    names = {'C','C#','D','D#','E','F','F#','G','G#','A','A#','B'};
    idx = mod(midi, 12) + 1;
    noteStr = [names{idx}, num2str(octave)];
end

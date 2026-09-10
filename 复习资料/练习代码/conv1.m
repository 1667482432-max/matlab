function [w,tw] = conv1(u,tu,v,tv)
% CONV1 课件函数：用离散卷积近似连续时间卷积。
% u、v 为等间隔采样的信号；tu、tv 为它们各自的时间轴。
% w 为卷积结果；tw 为 w 对应的时间轴。
T = tu(2)-tu(1);
if abs((tv(2)-tv(1))-T) > 1e-12
    error('conv1:SampleInterval', 'u 和 v 的采样间隔必须相同。');
end
w = T*conv(double(u),double(v));
tw = tu(1)+tv(1)+T*(0:numel(u)+numel(v)-2).';
end

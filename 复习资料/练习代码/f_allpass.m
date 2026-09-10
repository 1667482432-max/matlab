function [b,a] = f_allpass(p)
% 旧全通样题：极点非零、在单位圆内，根式增益k=1。
% 使用 Signal Processing Toolbox 的 zp2tf 建立系统系数。
p = p(:);
z = 1./conj(p);                 % 共轭反演，逐元素相除
[b,a] = zp2tf(z,p,1);
end

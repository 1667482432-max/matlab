function [b,a] = f_allpass(p)
% 旧全通样题：极点非零、在单位圆内，根式增益k=1。
% 使用基础MATLAB的poly，适用于本题分子分母等阶的构造。
p = p(:);
z = 1./conj(p);                 % 共轭反演，逐元素相除
b = poly(z);                   % 以z为根的首一多项式
a = poly(p);                   % 以p为根的首一多项式
% 工具箱写法：[b,a]=zp2tf(z,p,1);
end

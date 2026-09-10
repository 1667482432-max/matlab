%% 第3课：差分方程、响应、频响（Signal Processing Toolbox）
% y(n)-0.2*y(n-1)+0.1*y(n-2)=x(n)-x(n-1)，零初始状态。
clear;
close all;
clc;

a = [1 -0.2 0.1];                  % 输出y的系数
b = [1 -1];                        % 输入x的系数
n = 0:39;
x = sin(pi*n/10)+cos(pi*n/6);
y = filter(b,a,x);
h = impz(b,a,numel(n));             % 直接计算 n=0:39 的单位样值响应

figure('Name','Lesson 3 - time');
subplot(3,1,1); stem(n,x); grid on; title('Input');
subplot(3,1,2); stem(n,y); grid on; title('Output');
subplot(3,1,3); stem(n,h); grid on; title('Impulse response'); xlabel('n');

% 课程工具箱函数：自动画幅频响应和相频响应。
figure('Name','Lesson 3 - frequency');
freqz(b,a,512);

% 课程工具箱函数：画零点和极点在 z 平面中的位置。
figure('Name','Lesson 3 - zeros and poles');
zplane(b,a);
% 验证：手算h(0)=1,h(1)=-0.8,h(2)=-0.26；极点模均小于1。
% 练习：把输入改成单位阶跃，观察输出最后趋向什么数。

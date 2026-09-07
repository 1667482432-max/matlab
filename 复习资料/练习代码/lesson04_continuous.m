%% 第4课：连续系统响应（仅需 MATLAB，使用ode45）
% 对应考题：y''+1.2*y'+y=x'+x，零初始状态，x为0<=t<2矩形。
% 课程标准方法是tf/lsim。当前没有控制工具箱，先用等价状态实现。
% 令v''+1.2*v'+v=x，y=v'+v，避免直接数值微分矩形输入。
clear;
close all;
clc;

dt = 0.01;
t = (0:dt:10).';
x = double((t>=0)&(t<2));
opts = odeset('RelTol',1e-9,'AbsTol',1e-11);

% 在输入切换处拆开积分，避免跨越不连续点。
[t1,v1] = ode45(@(tt,v) [v(2);-v(1)-1.2*v(2)+1], ...
    (0:dt:2).',[0;0],opts);
[t2,v2] = ode45(@(tt,v) [v(2);-v(1)-1.2*v(2)], ...
    (2:dt:10).',v1(end,:).',opts);
v = [v1;v2(2:end,:)];
y = v(:,1)+v(:,2);

% 单位冲激使v'从0跳至1，本系统无直通项。
[~,vh] = ode45(@(tt,v) [v(2);-v(1)-1.2*v(2)],t,[0;1],opts);
h = vh(:,1)+vh(:,2);
[~,vg] = ode45(@(tt,v) [v(2);-v(1)-1.2*v(2)+1],t,[0;0],opts);
g = vg(:,1)+vg(:,2);

figure('Name','Lesson 4');
subplot(2,2,1); plot(t,x); grid on; title('Input'); xlabel('t / s');
subplot(2,2,2); plot(t,y); grid on; title('Zero-state response'); xlabel('t / s');
subplot(2,2,3); plot(t,h); grid on; title('Impulse response'); xlabel('t / s');
subplot(2,2,4); plot(t,g); grid on; title('Step response'); xlabel('t / s');

% 工具箱齐全时优先学习以下考题写法：
% sys = tf([1 1],[1 1.2 1]);
% y = lsim(sys,x,t);   % 数值输入插值在跳变附近可能与理想矩形略不同
% h = impulse(sys,t);
% g = step(sys,t);
% 验证：h(0+)=1，g(0)=0，g最终趋近1，矩形输入输出最终衰减至0。
% 不要求第一轮背下ode45写法，重点识别输入、输出与两类响应。

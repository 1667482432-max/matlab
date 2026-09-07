%% 第3课：差分方程、响应、频响（仅需 MATLAB）
% y(n)-0.2*y(n-1)+0.1*y(n-2)=x(n)-x(n-1)，零初始状态。
clear;
close all;
clc;

a = [1 -0.2 0.1];                  % 输出y的系数
b = [1 -1];                        % 输入x的系数
n = 0:39;
x = sin(pi*n/10)+cos(pi*n/6);
y = filter(b,a,x);
d = [1 zeros(1,numel(n)-1)];
h = filter(b,a,d);                  % 等价于指定长度的单位样值响应

figure('Name','Lesson 3 - time');
subplot(3,1,1); stem(n,x); grid on; title('Input');
subplot(3,1,2); stem(n,y); grid on; title('Output');
subplot(3,1,3); stem(n,h); grid on; title('Impulse response'); xlabel('n');

% 按H(e^jw)定义求值，避免当前电脑缺少freqz。
w = linspace(0,pi,512).';
q = exp(-1i*w);                     % q=z^(-1)
H = polyval(fliplr(b),q)./polyval(fliplr(a),q);
figure('Name','Lesson 3 - frequency');
subplot(2,1,1); plot(w/pi,abs(H)); grid on;
xlabel('w / pi'); ylabel('|H|'); title('Magnitude');
subplot(2,1,2); plot(w/pi,unwrap(angle(H))); grid on;
xlabel('w / pi'); ylabel('Phase / rad'); title('Phase');

% 有信号处理工具箱时的课程写法：
% [h,n] = impz(b,a,40);
% [H,w] = freqz(b,a,512);
% figure; zplane(b,a);
% 验证：手算h(0)=1,h(1)=-0.8,h(2)=-0.26；极点模均小于1。
% 练习：把输入改成单位阶跃，观察输出最后趋向什么数。

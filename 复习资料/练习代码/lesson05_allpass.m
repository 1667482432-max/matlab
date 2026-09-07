%% 第5课：全通样题完整练习（仅需 MATLAB；同目录需要f_allpass.m）
clear;
close all;
clc;

p = [1/2+1i/3;1/2-1i/3;1/3];
[b,a] = f_allpass(p);
n = 0:59;
h = filter(b,a,[1 zeros(1,59)]);

w = linspace(0,pi,1024).';
q = exp(-1i*w);
H = polyval(fliplr(b),q)./polyval(fliplr(a),q);
figure('Name','Lesson 5 - system');
subplot(3,1,1); stem(n,h); grid on; title('Impulse response'); xlabel('n');
subplot(3,1,2); plot(w/pi,abs(H)); grid on;
ylim([0 10]); title('Constant magnitude = 108/13'); xlabel('w / pi');
subplot(3,1,3); plot(w/pi,unwrap(angle(H))); grid on;
title('Phase'); xlabel('w / pi'); ylabel('rad');

Y = zeros(9,numel(n));
figure('Name','Lesson 5 - nine outputs','Position',[100 100 1000 750]);
for k = 1:9
    x = 1+sin(pi*n/k)+cos(2*pi*n/k);
    Y(k,:) = filter(b,a,x);
    subplot(3,3,k);
    stem(n,Y(k,:));
    grid on; title(['k=',num2str(k)]); xlabel('n');
end

% 本题不要求单位幅度；abs(H)应为常数108/13，约8.3077。
% 课程工具箱写法：figure;impz(b,a); figure;freqz(b,a);
% 练习A：遮住f_allpass代码，重新写函数。
% 练习B：只输入一个非零稳定极点0.5，函数是否仍然适用？
% 练习C：把九宫格改成k=1:6的3行2列布局。

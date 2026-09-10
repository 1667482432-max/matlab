%% 第5课：全通样题完整练习（Signal Processing Toolbox；同目录需要f_allpass.m）
clear;
close all;
clc;

p = [1/2+1i/3;1/2-1i/3;1/3];
[b,a] = f_allpass(p);
n = 0:59;

% 课程工具箱写法：分别画单位样值响应、频率响应和零极点图。
figure('Name','Lesson 5 - impulse response');
impz(b,a,60);

figure('Name','Lesson 5 - frequency response');
freqz(b,a,1024);

figure('Name','Lesson 5 - zeros and poles');
zplane(b,a);

Y = zeros(9,numel(n));
figure('Name','Lesson 5 - nine outputs','Position',[100 100 1000 750]);
for k = 1:9
    x = 1+sin(pi*n/k)+cos(2*pi*n/k);
    Y(k,:) = filter(b,a,x);
    subplot(3,3,k);
    stem(n,Y(k,:));
    grid on; title(['k=',num2str(k)]); xlabel('n');
end

% 本题不要求单位幅度；幅频响应应为常数108/13，约8.3077。
% 练习A：遮住f_allpass代码，重新写函数。
% 练习B：只输入一个非零稳定极点0.5，函数是否仍然适用？
% 练习C：把九宫格改成k=1:6的3行2列布局。

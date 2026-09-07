%% 第2课：条件造信号、循环、四宫格（仅需 MATLAB）
clear;
close all;
clc;

n = -5:20;
u = double(n>=0);                    % 本例约定u(0)=1
d = double(n==0);                    % 离散单位样值
r = double((n>=0)&(n<4));            % 在0,1,2,3为1
train = double((n>=0)&(mod(n,5)==0)); % 非负区间内每隔5点有一个脉冲
signals = [u;d;r;train];             % 每行存一个信号
names = {'Step','Impulse','Rectangle','Pulse train'};

figure('Name','Lesson 2');
for k = 1:4
    subplot(2,2,k);
    stem(n,signals(k,:),'filled');
    grid on; xlabel('n'); title(names{k});
end

% 练习A：把矩形区间改成2<=n<7，应有5个非零点。
% 练习B：把脉冲串间隔改成3。
% 练习C：不使用signals矩阵，自己重写四个subplot。

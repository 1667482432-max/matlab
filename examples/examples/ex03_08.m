clear;
close all;
clc;


% ex03_08.m  |  例3.8 · 卷积图解  |  AI 生成，已校验，R2023b
% 例3.8 卷积图解：r(t)=e(t)*h(t) 的反褶-移位-相乘-积分过程
% e(t)：不对称三角脉冲（0~0.5 升到 1、0.5~2 降回 0）；h(t)=exp(-t)u(t)
e = @(x) (x>=0 & x<=0.5).*(x/0.5) + (x>0.5 & x<=2).*((2-x)/1.5);  % 用函数句柄定义信号，便于对不同自变量求值
hfun = @(x) exp(-x).*(x>=0);

dt    = 0.01;
tau   = -3:dt:6;        % 积分变量 tau 的网格
h_tau = hfun(tau);      % 固定的 h(tau)

% 在每个时刻 t 上，按定义 r(t)=积分 h(tau)e(t-tau)dtau 求乘积曲线下的面积
tr = -3:dt:6;
r  = zeros(size(tr));
for k = 1:numel(tr)
    es   = e(tr(k) - tau);            % e(t-tau)：一步完成反褶(-tau)+右移(t)
    r(k) = trapz(tau, h_tau .* es);   % 乘积的面积（trapz 梯形法数值积分）
end

t_snap = [-0.5 0.7 1.5 3.0];          % 四个代表时刻：未重叠 / 上升 / 过峰 / 移出
figure('Position',[100 100 900 1750]);% 5 个子图竖排，按子图数加高画布、避免过扁
N = numel(t_snap);
for i = 1:N
    subplot(N+1,1,i);
    es = e(t_snap(i) - tau);          % 该时刻反褶移位后的 e(t-tau)
    pr = h_tau .* es;                 % 乘积
    fill([tau fliplr(tau)], [zeros(size(pr)) fliplr(pr)], [.80 .80 .80], 'EdgeColor','none'); hold on;  % 乘积阴影
    p1 = plot(tau, h_tau, 'b-', 'LineWidth',2);   % h(tau)
    p2 = plot(tau, es,    'r--','LineWidth',2);   % e(t-tau)
    grid on; xlim([-3 6]); ylim([0 1.1]); xticks(-3:6); yticks([0 0.5 1]);
    set(gca,'FontSize',20);
    title(sprintf('t = %.1f,   r(t) = %.3f', t_snap(i), trapz(tau,pr)),'FontSize',20);  % 标题标出该时刻乘积面积
    if i==1, legend([p1 p2],{'h(\tau)','e(t-\tau)'},'FontSize',16,'Location','northeast'); end
    if i==N, xlabel('\tau','FontSize',20); end
    hold off;
end
subplot(N+1,1,N+1);                   % 第 5 格：完整 r(t)
plot(tr, r, 'k-', 'LineWidth',2); hold on;
rs = zeros(size(t_snap));             % 各快照时刻的 r 值
for i = 1:N, rs(i) = trapz(tau, h_tau.*e(t_snap(i)-tau)); end
plot(t_snap, rs, 'ro', 'MarkerFaceColor','r', 'MarkerSize',10);  % 标出各快照的 r 值
grid on; xlim([-3 6]); ylim([0 0.55]); xticks(-3:6); yticks([0 0.5]);
set(gca,'FontSize',20);
xlabel('t','FontSize',20); ylabel('r(t)','FontSize',20);
title('卷积结果 r(t) = e(t) * h(t)','FontSize',20);
hold off;

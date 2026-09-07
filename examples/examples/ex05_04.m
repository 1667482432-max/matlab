clear;
close all;
clc;


% ex05_04.m  |  例5.4 · 零极点→时域  |  AI 生成，已校验，R2023b
% 观察一阶极点位置对系统冲激响应的影响
% 极点实部 σ 取 -1, 0, 1 （从左到右）
% 极点虚部 ω 取  0, 1, 2, 3 （从下到上）
% 网格布局与 s 平面分布一致

sigma_vals = [-1, 0, 1];      % 列（左→右：负→零→正）
omega_vals = [0, 1, 2, 3];   % 行（下→上：ω 递增）
nCols = length(sigma_vals);
nRows = length(omega_vals);

Tfinal = 5;                  % 统一时间范围 0 ~ 5 s
dt = 0.01;
t = 0:dt:Tfinal;             % 所有子图共用时间轴

% 画布尺寸：根据行数加高，避免过扁
figure('Position', [100, 100, 900, 350 * nRows]);

for row = 1:nRows
    % 实际虚部：最下行 ω=0，最上行 ω 最大
    omega = omega_vals(nRows - row + 1);
    for col = 1:nCols
        sigma = sigma_vals(col);
        
        % 构造极点：虚部为零时单个实极点，否则一对共轭极点
        if omega == 0
            p = sigma;                     % 实极点
        else
            p = [sigma + 1i*omega; sigma - 1i*omega]; % 共轭极点对
        end
        
        % 由零极点生成传递函数（无零点，增益 k=1）
        [b, a] = zp2tf([], p, 1);
        sys = tf(b, a);
        
        % 求解冲激响应
        y = impulse(sys, t);
        
        % 子图绘制
        subplot(nRows, nCols, (row - 1) * nCols + col);
        plot(t, y, 'b', 'LineWidth', 2);
        grid on;
        xlim([0, Tfinal]);
        ylim('auto');          % 各子图纵坐标自适应，完整显示波形
        
        % 标题标明极点位置
        title(sprintf('σ = %.1f,  ω = %.1f', sigma, omega), 'FontSize', 24);
        xlabel('Time (s)', 'FontSize', 24);
        ylabel('Amplitude', 'FontSize', 24);
        set(gca, 'FontSize', 24);
    end
end

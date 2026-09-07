% ex19_01.m  |  例19.1 · uifigure + 滑块调频率  |  AI 生成，已校验，R2023b
function ex19_01
% 创建图形界面：用滑块调节正弦波频率

% 创建 uifigure 窗口
fig = uifigure('Name', '正弦波频率调节', ...
               'Position', [400 300 600 400]);

% 创建 uiaxes 用于显示波形
ax = uiaxes(fig, ...
            'Position', [50 80 500 280]);
xlabel(ax, '时间 (s)');
ylabel(ax, '振幅');
title(ax, 'sin(2\pi f t)');
grid(ax, 'on');

% 时间向量（0~1秒，采样 1000 点）
t = linspace(0, 1, 1000);

% 初始频率
f0 = 2;

% 绘制初始波形，并保存曲线句柄
hLine = plot(ax, t, sin(2*pi*f0*t), 'LineWidth', 1.5);
ax.YLim = [-1.2 1.2];

% 创建滑块：频率范围 1~10 Hz，默认值 2，拖动时实时更新
sld = uislider(fig, ...
               'Position', [100 30 400 3], ...
               'Limits', [1 10], ...
               'Value', f0, ...
               'ValueChangingFcn', @(src, event) updateWave(event.Value));

    % 嵌套的局部函数：根据频率更新波形
    function updateWave(f)
        hLine.YData = sin(2*pi*f*t);
    end
end

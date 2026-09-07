% ex19_02.m  |  例19.2 · 多控件协同：下拉+滑块+按钮  |  AI 生成，已校验，R2023b
function ex19_02
% ex19_02 - 创建互动信号绘制界面
%   - 下拉框选择：正弦 / 方波
%   - 滑块调节频率：1 ~ 10 Hz
%   - 按钮触发绘图
%   - 界面初始化时自动绘制默认信号

    % 创建图形窗口
    fig = uifigure('Name', '信号绘制', 'Position', [100 100 650 400]);

    % 信号类型下拉框
    dd = uidropdown(fig, ...
        'Items', {'正弦', '方波'}, ...
        'Value', '正弦', ...
        'Position', [50 350 100 22]);

    % 频率滑块 (1~10 Hz, 初始5 Hz)
    sld = uislider(fig, ...
        'Limits', [1 10], ...
        'Value', 5, ...
        'Position', [200 360 150 3]);  % 高度设为3像素，与下拉框视觉对齐

    % 绘制按钮
    btn = uibutton(fig, ...
        'Text', '绘制', ...
        'Position', [400 350 60 22], ...
        'ButtonPushedFcn', @(btn,event) plotSignal());

    % 坐标轴
    ax = uiaxes(fig, ...
        'Position', [50 50 550 280]);

    % ---------- 嵌套函数：执行绘图 ----------
    function plotSignal()
        % 读取当前控件值
        type = dd.Value;       % 下拉框当前值
        freq = sld.Value;      % 滑块当前频率

        % 生成时间轴 (1秒，足够观察波形)
        t = 0:0.001:1;

        % 根据类型生成信号
        if strcmp(type, '正弦')
            y = sin(2 * pi * freq * t);
        else  % 方波（使用符号函数生成 -1/1 方波，无需工具箱）
            y = sign(sin(2 * pi * freq * t));
        end

        % 在坐标轴上绘图
        cla(ax);               % 清除原有图形
        plot(ax, t, y);
        xlabel(ax, '时间 (s)');
        ylabel(ax, '幅度');
        title(ax, sprintf('信号类型: %s,  频率: %.1f Hz', type, freq));
        grid(ax, 'on');
        axis(ax, 'tight');
    end

    % 界面创建后立即绘制初始图形（正弦, 5 Hz）
    plotSignal();
end

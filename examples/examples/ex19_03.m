% ex19_03.m  |  例19.3 · 时域+频谱双轴查看器  |  AI 生成，已校验，R2023b
function ex19_03
    % 信号时域/频谱查看器
    % 使用纯代码创建 uifigure 界面，包含：
    % - uidropdown 选择信号类型（正弦 / 方波 / Chirp）
    % - uislider 调节频率
    % - 上方 uiaxes 绘制时域波形
    % - 下方 uiaxes 绘制幅度谱（fft + fftshift，零频居中）

    % 创建主窗口
    fig = uifigure('Name', '信号时域/频谱查看器', ...
                   'Position', [100, 100, 800, 600]);

    % 使用网格布局管理器：2行×2列
    % 左侧列用于两个坐标轴，右侧列用于控件
    gl = uigridlayout(fig, [2, 2]);
    gl.RowHeight = {'1x', '1x'};
    gl.ColumnWidth = {'1x', 150};
    gl.Padding = [10, 10, 10, 10];
    gl.RowSpacing = 5;
    gl.ColumnSpacing = 10;

    % 创建上方坐标轴：时域波形
    axTime = uiaxes(gl);
    axTime.Layout.Row = 1;
    axTime.Layout.Column = 1;
    title(axTime, '时域波形');
    xlabel(axTime, '时间 (s)');
    ylabel(axTime, '幅度');
    grid(axTime, 'on');

    % 创建下方坐标轴：幅度谱
    axFreq = uiaxes(gl);
    axFreq.Layout.Row = 2;
    axFreq.Layout.Column = 1;
    title(axFreq, '幅度谱 (双边，零频居中)');
    xlabel(axFreq, '频率 (Hz)');
    ylabel(axFreq, '幅度');
    grid(axFreq, 'on');

    % 右侧控件面板直接放在网格的第二列（跨两行）
    % 使用一个垂直布局的面板
    pnl = uipanel(gl, 'Title', '控制面板', 'FontSize', 12);
    pnl.Layout.Row = [1, 2];
    pnl.Layout.Column = 2;
    pnlInner = uigridlayout(pnl, [5, 1], ...
        'RowHeight', {30, 30, 30, 30, 30}, ...
        'Padding', [10, 10, 10, 10], ...
        'RowSpacing', 15);

    % 下拉框：信号类型
    uilabel(pnlInner, 'Text', '信号类型:');
    dd = uidropdown(pnlInner, ...
        'Items', {'正弦', '方波', 'Chirp'}, ...
        'Value', '正弦', ...
        'ValueChangedFcn', @(src, ~) updatePlot());

    % 滑块：频率
    uilabel(pnlInner, 'Text', '频率 (Hz):');
    sld = uislider(pnlInner, ...
        'Limits', [1, 100], ...
        'Value', 50, ...
        'MajorTicks', [1, 25, 50, 75, 100], ...
        'ValueChangingFcn', @(src, ~) updatePlot());

    % 采样参数（固定）
    Fs = 1000;          % 采样率 Hz
    T = 1;              % 信号时长 秒
    t = 0:1/Fs:T-1/Fs;  % 时间向量
    N = length(t);      % 点数 (1000)
    % 频率轴（fftshift后）
    freq = (-N/2:N/2-1) * (Fs/N);

    % 初始绘制
    updatePlot();

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 更新绘图函数（嵌套函数，可直接访问控件和参数）
    function updatePlot()
        % 获取当前设置
        sigType = dd.Value;
        f0 = sld.Value;   % 当前滑块频率值

        % 根据所选信号类型生成时域数据 y
        switch sigType
            case '正弦'
                y = sin(2 * pi * f0 * t);
            case '方波'
                % square 函数需要 Signal Processing Toolbox
                y = square(2 * pi * f0 * t);
            case 'Chirp'
                % 线性调频：起始频率 0 Hz，终止频率 f0 Hz
                y = chirp(t, 0, t(end), f0);
        end

        % 计算幅度谱（fft + fftshift，双边）
        Y = fft(y);
        Yshifted = fftshift(Y);
        mag = abs(Yshifted) / N;   % 幅度归一化（除以点数）

        % 更新时域坐标轴
        plot(axTime, t, y, 'b-', 'LineWidth', 1.2);
        xlim(axTime, [0, T]);
        ylim(axTime, [-1.2, 1.2]);
        title(axTime, ['时域波形 (', sigType, ', f = ', num2str(f0, '%.1f'), ' Hz)']);

        % 更新频域坐标轴
        plot(axFreq, freq, mag, 'r-', 'LineWidth', 1.2);
        xlim(axFreq, [-Fs/2, Fs/2]);
        % 动态调整 y 轴范围，使谱线清晰可见
        maxMag = max(mag);
        if maxMag > 0
            ylim(axFreq, [0, maxMag * 1.1]);
        end
        title(axFreq, '幅度谱 (双边，零频居中)');
    end
end

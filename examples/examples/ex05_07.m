% ex05_07.m  |  例5.7 · 二阶谐振 app  |  AI 生成，已校验，R2023b
function ex05_07
% 二阶谐振系统交互演示：H(s) = s / (s^2 + 2*alpha*s + omega0^2), omega0 = 1
% 阻尼 alpha ∈ [0, 1]，观察极点移动对零极点图、冲激响应、幅频和相频响应的影响

% --------------------- 参数与共享变量 ---------------------
omega0 = 1;                     % 自然频率
alpha = 0;                      % 当前阻尼系数
h_timer = [];                   % 定时器句柄
is_playing = false;             % 播放状态标志

% --------------------- 创建图形界面 ---------------------
fig = figure('Name', '二阶谐振系统动态演示', 'NumberTitle', 'off', ...
             'Position', [100, 100, 900, 700], ...
             'CloseRequestFcn', @close_fig);

% 四个子图
ax1 = subplot(2, 2, 1);        % 零极点图
title(ax1, '零极点图');
xlabel(ax1, '实部'); ylabel(ax1, '虚部');
axis equal; grid on; hold on;

ax2 = subplot(2, 2, 2);        % 冲激响应
title(ax2, '冲激响应');
xlabel(ax2, '时间 (s)'); ylabel(ax2, '幅度');
grid on; hold on;

ax3 = subplot(2, 2, 3);        % 幅频响应
title(ax3, '幅频响应');
xlabel(ax3, '频率 (rad/s)'); ylabel(ax3, '幅度');
grid on; hold on;

ax4 = subplot(2, 2, 4);        % 相频响应
title(ax4, '相频响应');
xlabel(ax4, '频率 (rad/s)'); ylabel(ax4, '相位 (rad)');
grid on; hold on;

% 滑动条
slider = uicontrol('Style', 'slider', ...
                   'Units', 'normalized', ...
                   'Position', [0.15, 0.02, 0.6, 0.04], ...
                   'Min', 0, 'Max', omega0, 'Value', alpha, ...
                   'Callback', @slider_callback);
% 显示当前 alpha 值
alpha_txt = uicontrol('Style', 'text', ...
                      'Units', 'normalized', ...
                      'Position', [0.15, 0.07, 0.2, 0.04], ...
                      'String', sprintf('alpha = %.2f', alpha), ...
                      'FontSize', 10, 'HorizontalAlignment', 'left');

% 播放/暂停按钮
btn_play = uicontrol('Style', 'pushbutton', ...
                     'Units', 'normalized', ...
                     'Position', [0.8, 0.02, 0.1, 0.04], ...
                     'String', '播放', ...
                     'Callback', @play_callback);

% --------------------- 更新所有子图的函数 ---------------------
    function update_plots(a)
        % a : 当前阻尼系数
        sys = tf([1 0], [1, 2*a, omega0^2]);   % 连续传递函数

        % 1. 零极点图
        cla(ax1);
        pzmap(ax1, sys);                       % 使用 pzmap 绘制
        axis(ax1, 'equal');
        xlim(ax1, [-1.5, 0.5]);
        ylim(ax1, [-1.5, 1.5]);
        grid(ax1, 'on');
        title(ax1, '零极点图');
        xlabel(ax1, '实部'); ylabel(ax1, '虚部');

        % 2. 冲激响应
        cla(ax2);
        impulse(ax2, sys, 0:0.01:20);          % 固定时间范围
        grid(ax2, 'on');
        title(ax2, '冲激响应');
        xlabel(ax2, '时间 (s)'); ylabel(ax2, '幅度');

        % 3. & 4. 幅频与相频响应 (用 freqs 计算)
        cla(ax3); cla(ax4);
        w = logspace(-1, 1, 500);              % 频率范围 0.1 ~ 10 rad/s
        [H, w] = freqs([1 0], [1, 2*a, omega0^2], w);
        mag = abs(H);
        phase = unwrap(angle(H));              % 相位解缠

        semilogx(ax3, w, mag);
        grid(ax3, 'on');
        title(ax3, '幅频响应');
        xlabel(ax3, '频率 (rad/s)'); ylabel(ax3, '幅度');

        semilogx(ax4, w, phase);
        grid(ax4, 'on');
        title(ax4, '相频响应');
        xlabel(ax4, '频率 (rad/s)'); ylabel(ax4, '相位 (rad)');

        drawnow;
    end

% --------------------- 滑动条回调 ---------------------
    function slider_callback(src, ~)
        alpha = get(src, 'Value');
        set(alpha_txt, 'String', sprintf('alpha = %.2f', alpha));
        % 如果正在自动播放，则停止播放
        if is_playing
            stop_timer();
            set(btn_play, 'String', '播放');
        end
        update_plots(alpha);
    end

% --------------------- 播放/暂停按钮回调 ---------------------
    function play_callback(~, ~)
        if is_playing
            stop_timer();
            set(btn_play, 'String', '播放');
        else
            start_timer();
            set(btn_play, 'String', '暂停');
        end
    end

% --------------------- 定时器控制 ---------------------
    function start_timer()
        if isempty(h_timer) || ~isvalid(h_timer)
            h_timer = timer('ExecutionMode', 'fixedRate', ...
                            'Period', 0.1, ...
                            'TimerFcn', @timer_callback);
        end
        is_playing = true;
        start(h_timer);
    end

    function stop_timer()
        if ~isempty(h_timer) && isvalid(h_timer)
            stop(h_timer);
        end
        is_playing = false;
    end

% --------------------- 定时器回调（自动更新 alpha） ---------------------
    function timer_callback(src, ~)
        step = 0.02;                            % 每次增加 0.02
        new_alpha = alpha + step;
        if new_alpha >= omega0
            new_alpha = omega0;
            stop(src);                          % 到达上限自动停止
            is_playing = false;
            set(btn_play, 'String', '播放');
        end
        alpha = new_alpha;
        set(slider, 'Value', alpha);
        set(alpha_txt, 'String', sprintf('alpha = %.2f', alpha));
        update_plots(alpha);
    end

% --------------------- 关闭窗口清理定时器 ---------------------
    function close_fig(~, ~)
        if ~isempty(h_timer) && isvalid(h_timer)
            stop(h_timer);
            delete(h_timer);
        end
        delete(fig);
    end

% --------------------- 初始化显示 ---------------------
update_plots(alpha);

end

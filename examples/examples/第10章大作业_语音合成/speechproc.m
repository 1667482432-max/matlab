% speechproc.m  |  语音分析骨架（代码精读·供本章例题调用）  |  R2023b
function speechproc()
    % ---- 定义常数 ----
    FL = 80;                % 帧长（10 毫秒 @ 8kHz）
    WL = 240;               % 窗长
    P  = 10;                % 预测系数个数
    s  = readspeech('voice.pcm', 100000);    % 载入语音 s（裸 int16）
    L  = length(s);         % 语音长度
    FN = floor(L/FL) - 2;   % 帧数
    [s0, fs] = audioread('voice.wav');        % 同一段语音，供 sound 试听

    % ---- 各路滤波器的缓存与状态 ----
    exc     = zeros(L,1);   zi_pre = zeros(P,1);   % 激励、预测滤波器状态
    s_rec   = zeros(L,1);   zi_rec = zeros(P,1);   % 重建语音、重建滤波器状态
    exc_syn = zeros(L,1);   zi_syn = zeros(P,1);   % 合成激励、合成滤波器状态
    s_syn   = zeros(L,1);                          % 合成语音
    nextpulse = 1;          % 下一个合成脉冲的全局位置（跨帧连续）
    hw = hamming(WL);       % 汉明窗

    % ---- 逐帧处理 ----
    for n = 3:FN
        % 对加窗后的本帧语音求预测系数（不要求掌握）
        s_w = s(n*FL-WL+1 : n*FL) .* hw;
        [A, E] = lpc(s_w, P);                % A 为预测系数，E 供后面算增益

        if n == 27
            % (3) 观察第 27 帧预测系统的零极点
            figure; zplane([], roots(A));
            title('第27帧预测系统的零极点');
        end

        s_f = s((n-1)*FL+1 : n*FL);          % 本帧语音

        % (4) 本帧语音过 分子A/分母1 的 FIR 求激励；zi_pre 帧间接力
        [exc((n-1)*FL+1 : n*FL), zi_pre] = filter(A, 1, s_f, zi_pre);

        % (5) 激励过 分子1/分母A 的全极点滤波器重建语音；zi_rec 帧间接力
        [s_rec((n-1)*FL+1 : n*FL), zi_rec] = ...
            filter(1, A, exc((n-1)*FL+1 : n*FL), zi_rec);

        s_Pitch = exc(n*FL-222 : n*FL);
        PT = findpitch(s_Pitch);             % 基音周期（不要求掌握）
        G  = sqrt(E*PT);                     % 合成激励增益（不要求掌握）

        % (10) 以 PT 为间隔、幅度 G 的脉冲串（跨帧连续），过全极点滤波器合成
        seg  = zeros(FL,1);
        base = (n-1)*FL;
        while nextpulse <= n*FL
            if nextpulse > base
                seg(nextpulse - base) = G;
            end
            nextpulse = nextpulse + PT;
        end
        exc_syn((n-1)*FL+1 : n*FL) = seg;
        [s_syn((n-1)*FL+1 : n*FL), zi_syn] = filter(1, A, seg, zi_syn);
    end

    % (6) 试听原始、激励、重建、合成四段语音，比较区别
    sound(s0, fs);                           % 原始语音
    % sound(exc/max(abs(exc)),     fs);      % 激励（尖脉冲串）
    % sound(s_rec/max(abs(s_rec)), fs);      % 重建语音（≈原始）
    % sound(s_syn/max(abs(s_syn)), fs);      % 合成语音（会说话的机器人腔）
return

% ---- 从 PCM 文件读入裸 int16 语音 ----
function s = readspeech(filename, L)
    fid = fopen(filename, 'r');
    s = fread(fid, L, 'int16');
    fclose(fid);
return

% ---- 计算一段语音的基音周期（不要求掌握）----
function PT = findpitch(s)
    [B, A] = butter(5, 700/4000);
    s = filter(B, A, s);
    R = zeros(143,1);
    for k = 1:143
        R(k) = s(144:223)' * s(144-k:223-k);
    end
    [R1,T1] = max(R(80:143));  T1 = T1 + 79;
    R1 = R1 / (norm(s(144-T1:223-T1)) + 1);
    [R2,T2] = max(R(40:79));   T2 = T2 + 39;
    R2 = R2 / (norm(s(144-T2:223-T2)) + 1);
    [R3,T3] = max(R(20:39));   T3 = T3 + 19;
    R3 = R3 / (norm(s(144-T3:223-T3)) + 1);
    Top = T1;  Rop = R1;
    if R2 >= 0.85*Rop,  Rop = R2;  Top = T2;  end
    if R3 >  0.85*Rop,  Rop = R3;  Top = T3;  end
    PT = Top;
return

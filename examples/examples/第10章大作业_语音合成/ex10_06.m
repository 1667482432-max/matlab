% ex10_06.m  |  例10.6 · 用真实系数合成语音  |  AI 生成，已校验，R2023b
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

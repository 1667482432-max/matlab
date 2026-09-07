% ex10_07.m  |  例10.7 · 变速不变调  |  AI 生成，已校验，R2023b
% (11) 变速不变调：本帧激励拉长一倍(FL_v=2*FL)，脉冲间隔 PT 不变、系数 A 不变
seg_v = zeros(FL_v,1);  base_v = (n-1)*FL_v;
while np_v <= n*FL_v
    if np_v > base_v,  seg_v(np_v-base_v) = G;  end
    np_v = np_v + PT;          % 脉冲间隔仍是 PT —— 基音周期不变、音调不变
end
exc_syn_v((n-1)*FL_v+1 : n*FL_v) = seg_v;
[s_syn_v((n-1)*FL_v+1 : n*FL_v), zi_syn_v] = filter(1, A, seg_v, zi_syn_v);

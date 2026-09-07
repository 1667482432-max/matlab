% ex10_05.m  |  例10.5 · 逐帧求激励与重建语音  |  AI 生成，已校验，R2023b
% (4) 本帧语音过 分子A/分母1 的 FIR，求激励；zi_pre 帧间接力
[exc((n-1)*FL+1 : n*FL), zi_pre] = filter(A, 1, s_f, zi_pre);

% (5) 激励过 分子1/分母A 的全极点滤波器，重建语音；zi_rec 帧间接力
[s_rec((n-1)*FL+1 : n*FL), zi_rec] = filter(1, A, exc((n-1)*FL+1 : n*FL), zi_rec);

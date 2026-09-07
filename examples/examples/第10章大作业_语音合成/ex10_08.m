% ex10_08.m  |  例10.8 · 变调不变速  |  AI 生成，已校验，R2023b
% (13) 变调不变速：极点幅角绝对值增大 dtheta（模不变、保共轭、不越负实轴）+ 基音周期减半
pol = roots(A);  ang = angle(pol);  mag = abs(pol);
ang2 = ang + sign(ang)*dtheta;       % |幅角|增大、符号不变 -> 旋转后仍共轭成对
ang2(ang2 >  pi) =  pi - 1e-6;       % 不转过负实轴
ang2(ang2 < -pi) = -pi + 1e-6;
A_t  = real(poly(mag .* exp(1j*ang2)));    % 由旋转后的极点重构该帧预测系数
PT_t = max(2, round(PT/2));                % 基音周期减半 -> 基频翻倍

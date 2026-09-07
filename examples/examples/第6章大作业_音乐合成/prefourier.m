function [t, omg, FT, IFT] = prefourier(Trg, N, OMGrg, K)
% prefourier —— 构造傅里叶变换/逆变换矩阵（§4.1.2 引出，现代化 j->1j）
% Trg, OMGrg：时域、频域的起止范围（二元矢量）；N, K：时域、频域抽样点数
% 返回：t 时域抽样点，omg 频域抽样点，FT 傅里叶变换矩阵，IFT 逆变换矩阵
T = Trg(2) - Trg(1);
t = linspace(Trg(1), Trg(2)-T/N, N)';
OMG = OMGrg(2) - OMGrg(1);
omg = linspace(OMGrg(1), OMGrg(2)-OMG/K, K)';
FT  = T/N * exp(-1j*(omg*t.'));
IFT = OMG/2/pi/K * exp(1j*(t*omg.'));
end

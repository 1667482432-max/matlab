function [t,omg,FT,IFT] = prefourier(Trg,N,OMGrg,K)
% PREFOURIER 课件函数：建立连续傅里叶变换及逆变换的数值近似矩阵。
% Trg=[时间起点 时间终点]；N 为时间采样点数。
% OMGrg=[角频率起点 角频率终点]；K 为频率采样点数。
T = (Trg(2)-Trg(1))/N;
t = linspace(Trg(1),Trg(2)-T,N).';
OMG = (OMGrg(2)-OMGrg(1))/K;
omg = linspace(OMGrg(1),OMGrg(2)-OMG,K).';
FT = T*exp(-1i*kron(omg,t.'));
IFT = OMG/(2*pi)*exp(1i*kron(t,omg.'));
end

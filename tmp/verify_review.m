function verify_review
cd('C:/Users/asus/Desktop/matlab/复习资料/练习代码');
set(groot,'defaultFigureVisible','off');
test01; test02; test03; test04; test05; test06; test07; test08;
fprintf('ALL 8 LESSONS PASSED ON %s\n',version);
close all;
end
function test01
run('lesson01_basics.m');
assert(numel(t)==101 && t(1)==0 && x(1)==0);
assert(max(abs(x-sin(6*pi*t)))<1e-12);
assert(numel(findobj(gcf,'Type','axes'))==2);
fprintf('PASS 01: sample grid and signal\n');
end
function test02
run('lesson02_signals.m');
assert(nnz(r)==4 && nnz(d)==1 && sum(train)==5);
assert(numel(findobj(gcf,'Type','axes'))==4);
fprintf('PASS 02: masks and four panels\n');
end
function test03
run('lesson03_discrete.m');
assert(max(abs(h(1:3)-[1 -0.8 -0.26]))<1e-12);
yr=zeros(size(x));
for k=1:numel(x)
    yr(k)=x(k);
    if k>1, yr(k)=yr(k)-x(k-1)+0.2*yr(k-1); end
    if k>2, yr(k)=yr(k)-0.1*yr(k-2); end
end
assert(max(abs(y-yr))<1e-12);
assert(all(abs(roots(a))<1));
assert(abs(H(1))<1e-12);
fprintf('PASS 03: filter vs independent recurrence, stability and DC\n');
end
function test04
run('lesson04_continuous.m');
assert(numel(t)==numel(y));
assert(abs(h(1)-1)<1e-12 && abs(g(1))<1e-12);
ha=exp(-0.6*t).*(cos(0.8*t)+0.5*sin(0.8*t));
ga=1+exp(-0.6*t).*(-cos(0.8*t)+0.5*sin(0.8*t));
tau=max(t-2,0);
gd=1+exp(-0.6*tau).*(-cos(0.8*tau)+0.5*sin(0.8*tau));
ya=ga-gd;
assert(max(abs(h-ha))<1e-7);
assert(max(abs(g-ga))<1e-7);
assert(max(abs(y-ya))<1e-7);
exportgraphics(gcf,'C:/Users/asus/Desktop/matlab/tmp/pdfs/qa_continuous.png','Resolution',120);
fprintf('PASS 04: all three continuous responses vs analytic expressions\n');
end
function test05
run('lesson05_allpass.m');
assert(all(size(Y)==[9 60]));
assert(max(abs(abs(H)-108/13))<1e-10);
assert(all(abs(roots(a))<1));
[b0,a0]=f_allpass(0.5); assert(norm(b0-[1 -2])<1e-12 && norm(a0-[1 -0.5])<1e-12);
assert(numel(findobj(gcf,'Type','axes'))==9);
exportgraphics(gcf,'C:/Users/asus/Desktop/matlab/tmp/pdfs/qa_allpass.png','Resolution',120);
fprintf('PASS 05: constant magnitude, variable-length function and nine panels\n');
end
function test06
run('lesson06_convolution.m');
assert(isequal(yd,[1 1 -1 -1]));
assert(max(abs(yfft-yd))<1e-12);
assert(numel(y)==numel(x)+numel(h)-1);
assert(max(abs(y(ty<=8)-reference(ty<=8)))<0.002);
fprintf('PASS 06: convolution vs FFT and analytic continuous response\n');
end
function test07
run('lesson07_spectrum.m');
[~,i2]=min(abs(f-2)); [~,i8]=min(abs(f-8));
assert(abs(amplitude(i2)-0.5)<1e-12 && abs(amplitude(i8)-0.25)<1e-12);
assert(abs(sum(abs(x).^2)-sum(abs(X).^2)/N)<1e-9);
assert(max(abs(Xct-conj(flipud(Xct))))<1e-10);
exportgraphics(gcf,'C:/Users/asus/Desktop/matlab/tmp/pdfs/qa_spectrum.png','Resolution',120);
fprintf('PASS 07: spectral peaks, Parseval and conjugate symmetry\n');
end
function test08
run('lesson08_sampling.m');
assert(max(abs(s3-s77))<1e-11);
assert(fs_new==50 && numel(td)==31 && numel(y_before)==31 && numel(y_after)==31);
assert(norm(y_before-y_after)>0.1);
fprintf('PASS 08: aliasing identity and changed sample rate\n');
end

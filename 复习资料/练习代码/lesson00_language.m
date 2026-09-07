%% 0. 纯语法入门：每次选中一节运行，先预测结果再核对
% 不包含绘图和信号。局部函数放在末尾，便于兼容课程版本。
clear;
clc;

%% 1. 变量、赋值、显示
price = 8;
count = 5;
discount = 6;
payment = price*count-discount;
disp(payment);                           % 34

%% 2. 行向量、列向量、矩阵与尺寸
row = 2:2:10;
col = [2;4;6;8;10];
A = [10 20;30 40];
disp(size(A));                           % [2 2]
disp(numel(row));                        % 5

%% 3. 下标与修改
v = [5 10 15 20 25];
selected = v([2 4]);
v(end) = 100;
disp(selected);                          % [10 20]
disp(v);                                 % [5 10 15 20 100]
disp(A(2,1));                            % 30

%% 4. 逐元素运算
prices = [3 5 8];
counts = [2 4 1];
costs = prices.*counts;
total_cost = sum(costs);
disp(costs);                             % [6 20 8]
disp(total_cost);                        % 34

%% 5. if判断一个数，逻辑索引筛选一组数
score = 75;
if score >= 90
    level = 'excellent';
elseif score >= 60
    level = 'pass';
else
    level = 'fail';
end
disp(level);                             % pass
scores = [52 67 88 91 45];
high_scores = scores(scores>=80);
disp(high_scores);                       % [88 91]

%% 6. 循环求和，并用另一种方法核对
total = 0;
for k = 1:10
    total = total+k;
end
disp(total);                             % 55
disp(sum(1:10));                         % 55

%% 7. 调用本文件末尾的局部函数
result = square_each([2 3 4]);
disp(result);                            % [4 9 16]
% 教程还安排了单独文件函数，需自己保存并练习调用。

function y = square_each(x)
y = x.^2;
end

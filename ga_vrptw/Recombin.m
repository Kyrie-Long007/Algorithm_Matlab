function children = Recombin(children, PC)
% 将选择得到的子代种群作为交叉的父代种群，按照一定的交叉概率和交叉动作交叉生成子代种群
% 输入：父代种群；交叉率
% 输出：子代种群
% 调用函数：Intercross

% 计算子代的个数
nChildren = size(children, 1);
% 以下直接包括了nChildren为奇数和偶数两种情况
% 为奇数，按1-2， 3-4， (nChildren-2)-(nChildren-1)，nChildren不参与交叉
% 为偶数，按1-2， 3-4， (nChildren-1)-(nChildren)
for i = 1:2:nChildren - mod(nChildren, 2)
    % 如果交叉率大于产生的随机数则进行交叉操作
    if PC >= rand
        % 交叉方式很多，这里使用两点交叉方法，使用函数的方式的好处是便于更换选择方法
        [children(i, :), children(i+1, :)] = Intercross(children(i, :), children(i+1, :));
        
    end
end

function [a, b] = Intercross(a, b)
% 两点交叉法（全局搜索，丰富种群的多样性，加快种群的收敛性，不和交叉前进行比较）
% 输入：a, b是两个待交叉的父代个体
% 输出：a, b是两个交叉完成之后的子代个体
% 调用函数：无

% 计算父代个体的长度
L = length(a);
% 随机选择两个交叉位置
r1 = randsrc(1, 1, [1:L]);
r2 = randsrc(1, 1, [1:L]);
if r1 ~= r2
    a0 = a;
    b0 = b;
    s = min([r1, r2]);
    e = max([r1, r2]);
    for i = s:e
        a1 = a;
        b1 = b;
        a(i) = b0(i);
        b(i) = a0(i);
        x = find(a==a(i));
        y=find(b==b(i));
        i1 = x(x~=i);
        i2 = y(y~=i);
        if ~isempty(i1)
            a(i1) = a1(i);
        end
        if ~isempty(i2)
            b(i2) = b1(i);
        end
    end
end
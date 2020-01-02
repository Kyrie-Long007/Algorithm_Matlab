function chrom = Reverse(NVEHICLE, M, MAXLOAD, demand, N, dis, timeWindow, serviceTime, children)
% 将变异得到的子代种群作为逆转的父代种群，逆转生成子代种群（贪心原则，只接受更好的解）
% 输入：顾客点需求矩阵；染色体长度（顾客点的数量）；车辆最大载重；车场与顾客点、顾客点与顾客点之间的距离矩阵；父代种群
% 输出：本代循环的子代种群（下一代循环的初试父代种群）
% 调用函数：无

% 计算子代的个数和个体的长度
[nChildren, L] = size(children);
% 计算逆转前路径的总长度
routes = Decode(demand, N, MAXLOAD, children);
[~, routesCost] = CalCost(NVEHICLE, M, dis, timeWindow, serviceTime, routes);
% 将children赋值给reverseChildren
reverseChildren = children;
for i = 1:nChildren
    r1 = randsrc(1, 1, [1:L]);
    r2 = randsrc(1, 1, [1:L]);
    mininverse=min([r1, r2]);
    maxinverse=max([r1, r2]);
    reverseChildren(i, mininverse:maxinverse) = children(i, maxinverse:-1:mininverse);
end
reverseRoutes = Decode(demand, N, MAXLOAD, reverseChildren);
[~, reverseRoutesCost] = CalCost(NVEHICLE, M, dis, timeWindow, serviceTime, reverseRoutes);
% 找出逆转后更好的解的索引
index = reverseRoutesCost < routesCost;
children(index, :) = reverseChildren(index, :);
chrom = children;
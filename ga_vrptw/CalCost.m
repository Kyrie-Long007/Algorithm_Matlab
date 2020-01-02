function [subRouteCost, routesCost] = CalCost(NVEHICLE, M, dis, timeWindow, serviceTime, routes)
% 计算解码后各子路径的长度和解码后总路径的成本
% 输入：车场与顾客点顾客点与顾客点之间的距离矩阵；车场和顾客点的时间窗矩阵；车场和顾客点的服务时间矩阵；解码后的路径
% 输出：各子路径的成本；总路径的成本
% 调用函数：无

% 单位时间 == 单位距离（长度）
% 启动车辆的固定成本系数、运输成本系数、等待成本系数、惩罚成本系数
fixedCost  = 1;
transportationCost = 1;
waitCost = 1;
penaltyCost = 1.2;

routesCost = zeros(size(routes, 1), 1);
% subRoute的个数是不确定的，所以不能分配确定的空间
subRouteCost = {};
% subRouteCost = {}作为存储数组
for i = 1: size(routes, 1)
    % 为了计算车辆数，去除route{i, :}中的空矩阵，注意这里是{routes{i, :}}，如果没有外面的{}，那么temp == routes{i, 1}，这里外面的{}很重要
    temp = {routes{i, :}};
    % 运用此函数还省去了以下判断routes{i, :}中是否含空值[]（if ~isempty(routes{i, j})）
    temp(cellfun(@isempty, temp)) = [];
    for j = 1:size(temp, 2)
        % 每换一条新的子路径，更新总经过时间、等待时间、延迟时间
        time = 0;
        waitTime = 0;
        penaltyTime = 0;
        % 判断是否超过了车辆约束，不用计算子路径的成本，直接令子路径的成本为惩罚因子即可
        if size(temp, 2) > NVEHICLE
            subRouteCost{i, j} = M;
            routesCost(i, :) = routesCost(i) + subRouteCost{i, j};
        % 没有超过车辆约束
        else
            subRoute = routes{i, j};
            % 如果一条子路径中只有一个顾客点，只需要计算车场到顾客点再回到车场往返的路径时间
            % 反之则需要计算车辆在顾客点之间的行驶时间
            if length(subRoute) == 1
                % 先计算第i个个体第j条子路径的成本
                % 注意subRoute(1)+1，因为nodeCoor的第一个点是车场，dis的第一行和第一列也都是车场离顾客点的距离，生成的顾客点是1~N，所以要加1
                time = time + dis(1, subRoute(1)+1);
                % 判断车辆到达第一个点（唯一）是否满足该点的时间窗约束
                if time < timeWindow(subRoute(1)+1, 1)
                    waitTime = waitTime + (timeWindow(subRoute(1)+1) - time);
                elseif time > timeWindow(subRoute(1)+1, 2)
                    penaltyTime = penaltyTime + (time - timeWindow(subRoute(1)+1, 2));
                end
                % 从车场出发服务顾客点后回车场的总时间
                time = time + serviceTime(subRoute(end)+1) + dis(subRoute(end)+1, 1);
                transportationTime = time - serviceTime(subRoute(1)+1);
                % 对于一条路径，判断车辆从车场出发服务顾客点后回车场的总时间是否满足车场的最晚时间窗约束
                if time > timeWindow(1, 2)
                    penaltyTime = penaltyTime + (time - timeWindow(1, 2));
                end
                % 每一条子路径的车辆数为1
                subRouteCost{i, j} = fixedCost * 1 + transportationCost * transportationTime + waitCost * waitTime + penaltyCost * penaltyTime;
                % 将第i个个体第j条子路径的成本加到第i个个体总路径的长度上
                routesCost(i) = routesCost(i) + subRouteCost{i, j};
            else
                % 计算车辆在车场到顾客点之间行驶的路径时间，注意subRoute(1)+1，因为nodeCoor的第一个点是车场
                time = time + dis(1, subRoute(1)+1);
                % 第一个顾客点相较于其他顾客点比较特殊，因为它是从车场出发，所以单独计算判断车辆到达第一个点（唯一）是否满足该点的时间窗约束
                if time < timeWindow(subRoute(1)+1, 1)
                    waitTime = waitTime + (timeWindow(subRoute(1)+1) - time);
                elseif time > timeWindow(subRoute(1)+1, 2)
                    penaltyTime = penaltyTime + (time - timeWindow(subRoute(1)+1, 2));
                end
                % 计算车辆在顾客点之间的行驶路径时间
                for k = 1:length(subRoute)-1
                    time = time + serviceTime(subRoute(k)+1) + dis(subRoute(k)+1, subRoute(k+1)+1);
                    % 判断车辆到达第k+1个点是否满足该点的时间窗约束
                    if time < timeWindow(subRoute(k+1)+1, 1)
                        waitTime = waitTime + timeWindow(subRoute(k+1)+1) - time;
                    elseif time > timeWindow(subRoute(k+1)+1, 2)
                        penaltyTime = penaltyTime + time - timeWindow(subRoute(k+1)+1, 2);
                    end
                end
                % 从车场出发服务顾客点后回车场的总时间（此时的k是循环出来的最后一个k，或者这里的k+1也可用end代替）
                time = time + serviceTime(subRoute(k+1)+1) + dis(subRoute(k+1)+1, 1);
                transportationTime = time - sum(serviceTime(subRoute(1)+1:subRoute(end)+1));
                % 对于一条路径，判断车辆从车场出发服务顾客点后回车场的总时间是否满足车场的最晚时间窗约束
                if time > timeWindow(1, 2)
                    penaltyTime = penaltyTime + (time - timeWindow(1, 2));
                end
                subRouteCost{i, j} = fixedCost * 1 + transportationCost * transportationTime + waitCost * waitTime + penaltyCost * penaltyTime;
                routesCost(i) = routesCost(i) + subRouteCost{i, j};
            end
        end
    end
end
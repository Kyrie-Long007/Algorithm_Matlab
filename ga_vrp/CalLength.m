function [subRouteLength, routesLength] = CalLength(NVEHICLE, M, dis, routes)
% 计算解码后各子路径的长度和解码后总路径的长度
% 输入：可使用的最大车辆数；违反最大车辆约束的惩罚因子；车场与顾客点顾客点与顾客点之间的距离矩阵；解码后的路径
% 输出：各子路径的长度；总路径的长度
% 调用函数：无

routesLength = zeros(size(routes, 1), 1);
% subRoute的个数是不确定的，所以不能分配确定的空间
subRouteLength = {};
% subRouteLength = {}作为存储数组，len作为变量用来计算每一条子路径的长度
for i = 1: size(routes, 1)
    % 为了计算车辆数，去除route{i, :}中的空矩阵，注意这里是{routes{i, :}}，如果没有外面的{}，那么temp == routes{i, 1}，这里外面的{}很重要
    temp = {routes{i, :}};
    % 运用此函数还省去了以下判断routes{i, :}中是否含空值[]（if ~isempty(routes{i, j})）
    temp(cellfun(@isempty, temp)) = [];
    for j = 1:size(temp, 2)
        % 判断是否超过了车辆约束，不用计算子路径的长度，直接令子路径的长度为惩罚因子即可
        if size(temp, 2) > NVEHICLE
            subRouteLength{i, j} = M;
            routesLength(i, :) = routesLength(i) + subRouteLength{i, j};
        % 没有超过车辆约束
        else
            % 每计算一次子路径的长度，len作为计算数据每条子路径长度的变量需要归0
            len = 0;
            subRoute = routes{i, j};
            % 如果一条子路径中只有一个顾客点，只需要计算车场到顾客点再回到车场往返的路径长度
            % 反之则需要计算车辆在顾客点之间的行驶距离
            if length(subRoute) == 1
                % 先计算第i个个体第j条子路径的长度
                % 注意subRoute(1)+1，因为nodeCoor的第一个点是车场，dis的第一行和第一列也都是车场离顾客点的距离，生成的顾客点是1~N，所以要加1
                len = len + dis(1, subRoute(1)+1) + dis(subRoute(1)+1, 1);
                subRouteLength{i, j} = len;
                % 将第i个个体第j条子路径的长度加到第i个个体总路径的长度上
                routesLength(i) = routesLength(i) + subRouteLength{i, j};
            else
                % 计算车辆在车场到顾客点之间行驶的路径长度，注意subRoute(1)+1，因为nodeCoor的第一个点是车场
                len = len + dis(1, subRoute(1)+1) + dis(subRoute(end)+1, 1);
                % 计算车辆在顾客点之间的行驶路径长度
                for k = 1:length(subRoute)-1
                    len = len + dis(subRoute(k)+1, subRoute(k+1)+1);
                end
                subRouteLength{i, j} = len;
                routesLength(i) = routesLength(i) + subRouteLength{i, j};
            end
        end
    end
end
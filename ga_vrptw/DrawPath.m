function DrawPath(nodeCoor, routes)
% 画出路径图（可画出一个个体或者多个个体）
% 输入：车场和顾客点的位置矩阵；解码后的路径
% 输出： 路径图
% 调用函数：无

for i = 1:size(routes, 1)
    % 每一个个体，画一个图
    figure
    % 车场
    scatter(nodeCoor(1, 1), nodeCoor(1, 2), 'rv')
    hold on
    % 顾客点
    scatter(nodeCoor(2:end, 1), nodeCoor(2:end, 2), 'go')
    hold on
    % axis([0, 35, 0, 25]);
    % 加注释（这里用p不要用i，i上面用过了）
    for p = 1:size(nodeCoor, 1)
    % 这里i-1可以将车场的注释记为0
        strTemp = sprintf('%d', p-1);
        text(nodeCoor(p, 1)+1, nodeCoor(p, 2)+1, strTemp, 'FontSize', 10);
    end
    for j = 1:size(routes, 2)
        % 这里保证每辆车的路径可以随机选择不同颜色（还可以记录已经跑过的车的路径颜色，若后面的颜色和之前的相同，则重新生成新的颜色）
        colors = ['r', 'g', 'b', 'c', 'm', 'y', 'k'];
        temp = randperm(length(colors));
        color = colors(temp(1));
        if ~isempty(routes{i, j})
            subRoute = routes{i, j};
            if length(subRoute) == 1
                % 因为车场的坐标时nodeCoor(1, 1)，所以使用subRoute里面的每一项作为nodeCoor的索引时都应该+1
                % 例如：subRoute(1) = 3，那么对于3这个顾客点对应的是nodeCoor(4, :)
                % 如果某车辆的配送路径只有一个点，那么只用画出车场到该点的往返路径即可（其实就是一条线，这里只画了从车场到第一个顾客点）
                plot([nodeCoor(1, 1), nodeCoor(subRoute(1)+1, 1)], [nodeCoor(1, 2), nodeCoor(subRoute(1)+1, 2)], color)
                hold on
            else
                % 画出车辆从车场到第一个顾客点的路径
                plot([nodeCoor(1, 1), nodeCoor(subRoute(1)+1, 1)], [nodeCoor(1, 2), nodeCoor(subRoute(1)+1, 2)], color)
                hold on
                % 画出和最后一个顾客点到车场的路径
                plot([nodeCoor(subRoute(end)+1, 1), nodeCoor(1, 1)], [nodeCoor(subRoute(end)+1, 2), nodeCoor(1, 2)], color)
                hold on
                % 画出车辆在顾客点之间的路径
                for k = 1:length(subRoute)-1
                    plot([nodeCoor(subRoute(k)+1, 1), nodeCoor(subRoute(k+1)+1, 1)], [nodeCoor(subRoute(k)+1, 2), nodeCoor(subRoute(k+1)+1, 2)], color)
                    hold on
                end
            end
        end
    end
end

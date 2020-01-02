function OutputPath(routes, subRouteLength, routesLength)
% 在屏幕上输出子路径及对应的长度、总路径的长度（可输出一个个体或多个个体）
% 输入：解码后的路径；解码后各子路径的长度；解码后总路径的长度
% 输出：子路径和对应的长度、总路径的长度
%  调用函数：无

% 这里不能使用length(chrom)，一开始输入的chrom是NIND*N维时，length(chrom) = NIND
%但是如果输入的chrom是一个个体（例如chrom(1, :)），那么length(chrom) = N
for i = 1:size(routes, 1)
    for j = 1:size(routes, 2)
        % 这里的判断条件是为了输出路径时不产生 "第4辆车的路径："这种情况
        if ~isempty(routes{i, j})
            subRoute = routes{i, j};
            disp(['第', num2str(j), '辆车的路径：', num2str(subRoute)])
            disp(['    子路径', num2str(j), '的长度：', num2str(subRouteLength{i, j})])
        else
            break
        end
    end
    % 输出总路径
    % 对于不同的个体，以换行来让输出更直观
    disp(['总路径长度：', num2str(routesLength(i))])
    disp(' ')
end


%{
输出示例：
>>OutputPath(demand, N, MAXLOAD, chrom(1:3, :));
第1辆车的路径：9  2  3
第2辆车的路径：10   1  11   8
第3辆车的路径：5  12   6   4
第4辆车的路径：7
 
第1辆车的路径：1  7  8
第2辆车的路径：10   9   4
第3辆车的路径：11   5  12   2   6
第4辆车的路径：3
 
第1辆车的路径：11  10   6
第2辆车的路径：4   5   8  12
第3辆车的路径：9  2  3  1  7
%}
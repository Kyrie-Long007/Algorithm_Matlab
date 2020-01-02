function routes = Decode(demand, N, MAXLOAD, chrom)
% 解码得到包含子路径的总路径，子路径用[]表示，总路径用{}表示（使用{}能够很有效的存储动态数组，类似python的dict）
% 输入：顾客点需求矩阵；染色体的长度（仅顾客点的数量）；车辆的最大载重；染色体（每一代或者每一代中的一个或几个）
% 输出：包含子路径的总路径
% 调用函数：无

% 按照每辆车装载量最大的贪心原则求出各条子路径
routes = {};
% 这里不用1:NIND的原因是，要是输入的chrom是一个随机个体，那么返回的routes也应该1*的cell而不是NIND*的cell
for i = 1:size(chrom, 1)
    s = chrom(i, :);
    load = 0;
    routeIndex = 1;
    for j = 1:N
        % 这里的s(j)+1是因为，demand(1) = 0是代表车场的需求
        load = load + demand(s(j)+1);
        if load > MAXLOAD
            j = j - 1;
            load = 0;
            routeIndex = [routeIndex j];
        end
    end
    routeIndex = [routeIndex N];
    nVehicle = length(routeIndex) - 1;

    % 假设routeIndex = [1, 3, 8, 12]，那么第一辆车访问的点就是s(1:3)，第二辆车是s(4:8)，最后一辆车是s(9:12)，这里要区分i是否为1 
    for k = 1:nVehicle
        if k == 1
            routes{i, k} = s(routeIndex(k):routeIndex(k+1));
        else
            routes{i, k} = s(routeIndex(k)+1:routeIndex(k+1));
        end
    end
end


            

            
        

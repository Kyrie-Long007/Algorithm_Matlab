function routes = Decode(demand, N, MAXLOAD, chrom)
% ����õ�������·������·������·����[]��ʾ����·����{}��ʾ��ʹ��{}�ܹ�����Ч�Ĵ洢��̬���飬����python��dict��
% ���룺�˿͵��������Ⱦɫ��ĳ��ȣ����˿͵����������������������أ�Ⱦɫ�壨ÿһ������ÿһ���е�һ���򼸸���
% �����������·������·��
% ���ú�������

% ����ÿ����װ��������̰��ԭ�����������·��
routes = {};
% ���ﲻ��1:NIND��ԭ���ǣ�Ҫ�������chrom��һ��������壬��ô���ص�routesҲӦ��1*��cell������NIND*��cell
for i = 1:size(chrom, 1)
    s = chrom(i, :);
    load = 0;
    routeIndex = 1;
    for j = 1:N
        % �����s(j)+1����Ϊ��demand(1) = 0�Ǵ�����������
        load = load + demand(s(j)+1);
        if load > MAXLOAD
            j = j - 1;
            load = 0;
            routeIndex = [routeIndex j];
        end
    end
    routeIndex = [routeIndex N];
    nVehicle = length(routeIndex) - 1;

    % ����routeIndex = [1, 3, 8, 12]����ô��һ�������ʵĵ����s(1:3)���ڶ�������s(4:8)�����һ������s(9:12)������Ҫ����i�Ƿ�Ϊ1 
    for k = 1:nVehicle
        if k == 1
            routes{i, k} = s(routeIndex(k):routeIndex(k+1));
        else
            routes{i, k} = s(routeIndex(k)+1:routeIndex(k+1));
        end
    end
end


            

            
        

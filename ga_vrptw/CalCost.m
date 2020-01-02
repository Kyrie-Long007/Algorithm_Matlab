function [subRouteCost, routesCost] = CalCost(NVEHICLE, M, dis, timeWindow, serviceTime, routes)
% �����������·���ĳ��Ⱥͽ������·���ĳɱ�
% ���룺������˿͵�˿͵���˿͵�֮��ľ�����󣻳����͹˿͵��ʱ�䴰���󣻳����͹˿͵�ķ���ʱ����󣻽�����·��
% ���������·���ĳɱ�����·���ĳɱ�
% ���ú�������

% ��λʱ�� == ��λ���루���ȣ�
% ���������Ĺ̶��ɱ�ϵ��������ɱ�ϵ�����ȴ��ɱ�ϵ�����ͷ��ɱ�ϵ��
fixedCost  = 1;
transportationCost = 1;
waitCost = 1;
penaltyCost = 1.2;

routesCost = zeros(size(routes, 1), 1);
% subRoute�ĸ����ǲ�ȷ���ģ����Բ��ܷ���ȷ���Ŀռ�
subRouteCost = {};
% subRouteCost = {}��Ϊ�洢���飬len��Ϊ������������ÿһ����·���ĳɱ�
for i = 1: size(routes, 1)
        % Ϊ�˼��㳵������ȥ��route{i, :}�еĿվ���ע��������{routes{i, :}}�����û�������{}����ôtemp == routes{i, 1}�����������{}����Ҫ
        temp = {routes{i, :}};
        % ���ô˺�����ʡȥ�������ж�routes{i, :}���Ƿ񺬿�ֵ[]��if ~isempty(routes{i, j})��
        temp(cellfun(@isempty, temp)) = [];
    for j = 1:size(temp, 2)
        % ÿ��һ���µ���·���������ܾ���ʱ�䡢�ȴ�ʱ�䡢�ӳ�ʱ��
        time = 0;
        waitTime = 0;
        penaltyTime = 0;
        % �ж��Ƿ񳬹��˳���Լ�������ü�����·���ĳɱ���ֱ������·���ĳɱ�Ϊ�ͷ����Ӽ���
        if size(temp, 2) > NVEHICLE
            subRouteCost{i, j} = M;
            routesCost(i, :) = routesCost(i) + subRouteCost{i, j};
        % û�г�������Լ��
        else
            subRoute = routes{i, j};
            % ���һ����·����ֻ��һ���˿͵㣬ֻ��Ҫ���㳵�����˿͵��ٻص�����������·��ʱ��
            % ��֮����Ҫ���㳵���ڹ˿͵�֮�����ʻʱ��
            if length(subRoute) == 1
                % �ȼ����i�������j����·���ĳɱ�
                % ע��subRoute(1)+1����ΪnodeCoor�ĵ�һ�����ǳ�����dis�ĵ�һ�к͵�һ��Ҳ���ǳ�����˿͵�ľ��룬���ɵĹ˿͵���1~N������Ҫ��1
                time = time + dis(1, subRoute(1)+1);
                % �жϳ��������һ���㣨Ψһ���Ƿ�����õ��ʱ�䴰Լ��
                if time < timeWindow(subRoute(1)+1, 1)
                    waitTime = waitTime + (timeWindow(subRoute(1)+1) - time);
                elseif time > timeWindow(subRoute(1)+1, 2)
                    penaltyTime = penaltyTime + (time - timeWindow(subRoute(1)+1, 2));
                end
                % �ӳ�����������˿͵��س�������ʱ��
                time = time + serviceTime(subRoute(end)+1) + dis(subRoute(end)+1, 1);
                transportationTime = time - serviceTime(subRoute(1)+1);
                % ����һ��·�����жϳ����ӳ�����������˿͵��س�������ʱ���Ƿ����㳵��������ʱ�䴰Լ��
                if time > timeWindow(1, 2)
                    penaltyTime = penaltyTime + (time - timeWindow(1, 2));
                end
                % ÿһ����·���ĳ�����Ϊ1
                subRouteCost{i, j} = fixedCost * 1 + transportationCost * transportationTime + waitCost * waitTime + penaltyCost * penaltyTime;
                % ����i�������j����·���ĳɱ��ӵ���i��������·���ĳ�����
                routesCost(i) = routesCost(i) + subRouteCost{i, j};
            else
                % ���㳵���ڳ������˿͵�֮����ʻ��·��ʱ�䣬ע��subRoute(1)+1����ΪnodeCoor�ĵ�һ�����ǳ���
                time = time + dis(1, subRoute(1)+1);
                % ��һ���˿͵�����������˿͵�Ƚ����⣬��Ϊ���Ǵӳ������������Ե��������жϳ��������һ���㣨Ψһ���Ƿ�����õ��ʱ�䴰Լ��
                if time < timeWindow(subRoute(1)+1, 1)
                    waitTime = waitTime + (timeWindow(subRoute(1)+1) - time);
                elseif time > timeWindow(subRoute(1)+1, 2)
                    penaltyTime = penaltyTime + (time - timeWindow(subRoute(1)+1, 2));
                end
                % ���㳵���ڹ˿͵�֮�����ʻ·��ʱ��
                for k = 1:length(subRoute)-1
                    time = time + serviceTime(subRoute(k)+1) + dis(subRoute(k)+1, subRoute(k+1)+1);
                    % �жϳ��������k+1�����Ƿ�����õ��ʱ�䴰Լ��
                    if time < timeWindow(subRoute(k+1)+1, 1)
                        waitTime = waitTime + timeWindow(subRoute(k+1)+1) - time;
                    elseif time > timeWindow(subRoute(k+1)+1, 2)
                        penaltyTime = penaltyTime + time - timeWindow(subRoute(k+1)+1, 2);
                    end
                end
                % �ӳ�����������˿͵��س�������ʱ�䣨��ʱ��k��ѭ�����������һ��k�����������k+1Ҳ����end���棩
                time = time + serviceTime(subRoute(k+1)+1) + dis(subRoute(k+1)+1, 1);
                transportationTime = time - sum(serviceTime(subRoute(1)+1:subRoute(end)+1));
                % ����һ��·�����жϳ����ӳ�����������˿͵��س�������ʱ���Ƿ����㳵��������ʱ�䴰Լ��
                if time > timeWindow(1, 2)
                    penaltyTime = penaltyTime + (time - timeWindow(1, 2));
                end
                subRouteCost{i, j} = fixedCost * 1 + transportationCost * transportationTime + waitCost * waitTime + penaltyCost * penaltyTime;
                routesCost(i) = routesCost(i) + subRouteCost{i, j};
            end
        end
    end
end
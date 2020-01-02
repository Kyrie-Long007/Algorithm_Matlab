function [subRouteLength, routesLength] = CalLength(NVEHICLE, M, dis, routes)
% �����������·���ĳ��Ⱥͽ������·���ĳ���
% ���룺��ʹ�õ����������Υ�������Լ���ĳͷ����ӣ�������˿͵�˿͵���˿͵�֮��ľ�����󣻽�����·��
% ���������·���ĳ��ȣ���·���ĳ���
% ���ú�������

routesLength = zeros(size(routes, 1), 1);
% subRoute�ĸ����ǲ�ȷ���ģ����Բ��ܷ���ȷ���Ŀռ�
subRouteLength = {};
% subRouteLength = {}��Ϊ�洢����
for i = 1: size(routes, 1)
    % Ϊ�˼��㳵������ȥ��route{i, :}�еĿվ���ע��������{routes{i, :}}�����û�������{}����ôtemp == routes{i, 1}�����������{}����Ҫ
    temp = {routes{i, :}};
    % ���ô˺�����ʡȥ�������ж�routes{i, :}���Ƿ񺬿�ֵ[]��if ~isempty(routes{i, j})��
    temp(cellfun(@isempty, temp)) = [];
    for j = 1:size(temp, 2)
        % �ж��Ƿ񳬹��˳���Լ�������ü�����·���ĳ��ȣ�ֱ������·���ĳ���Ϊ�ͷ����Ӽ���
        if size(temp, 2) > NVEHICLE
            subRouteLength{i, j} = M;
            routesLength(i, :) = routesLength(i) + subRouteLength{i, j};
        % û�г�������Լ��
        else
            % ÿ����һ����·���ĳ��ȣ�len��Ϊ��������ÿ����·�����ȵı�����Ҫ��0
            len = 0;
            subRoute = routes{i, j};
            % ���һ����·����ֻ��һ���˿͵㣬ֻ��Ҫ���㳵�����˿͵��ٻص�����������·������
            % ��֮����Ҫ���㳵���ڹ˿͵�֮�����ʻ����
            if length(subRoute) == 1
                % �ȼ����i�������j����·���ĳ���
                % ע��subRoute(1)+1����ΪnodeCoor�ĵ�һ�����ǳ�����dis�ĵ�һ�к͵�һ��Ҳ���ǳ�����˿͵�ľ��룬���ɵĹ˿͵���1~N������Ҫ��1
                len = len + dis(1, subRoute(1)+1) + dis(subRoute(1)+1, 1);
                subRouteLength{i, j} = len;
                % ����i�������j����·���ĳ��ȼӵ���i��������·���ĳ�����
                routesLength(i) = routesLength(i) + subRouteLength{i, j};
            else
                % ���㳵���ڳ������˿͵�֮����ʻ��·�����ȣ�ע��subRoute(1)+1����ΪnodeCoor�ĵ�һ�����ǳ���
                len = len + dis(1, subRoute(1)+1) + dis(subRoute(end)+1, 1);
                % ���㳵���ڹ˿͵�֮�����ʻ·������
                for k = 1:length(subRoute)-1
                    len = len + dis(subRoute(k)+1, subRoute(k+1)+1);
                end
                subRouteLength{i, j} = len;
                routesLength(i) = routesLength(i) + subRouteLength{i, j};
            end
        end
    end
end
function DrawPath(nodeCoor, routes)
% ����·��ͼ���ɻ���һ��������߶�����壩
% ���룺�����͹˿͵��λ�þ��󣻽�����·��
% ����� ·��ͼ
% ���ú�������

for i = 1:size(routes, 1)
    % ÿһ�����壬��һ��ͼ
    figure
    % ����
    scatter(nodeCoor(1, 1), nodeCoor(1, 2), 'rv')
    hold on
    % �˿͵�
    scatter(nodeCoor(2:end, 1), nodeCoor(2:end, 2), 'go')
    hold on
    % axis([0, 35, 0, 25]);
    % ��ע�ͣ�������p��Ҫ��i��i�����ù��ˣ�
    for p = 1:size(nodeCoor, 1)
    % ����i-1���Խ�������ע�ͼ�Ϊ0
        strTemp = sprintf('%d', p-1);
        text(nodeCoor(p, 1)+1, nodeCoor(p, 2)+1, strTemp, 'FontSize', 10);
    end
    for j = 1:size(routes, 2)
        % ���ﱣ֤ÿ������·���������ѡ��ͬ��ɫ�������Լ�¼�Ѿ��ܹ��ĳ���·����ɫ�����������ɫ��֮ǰ����ͬ�������������µ���ɫ��
        colors = ['r', 'g', 'b', 'c', 'm', 'y', 'k'];
        temp = randperm(length(colors));
        color = colors(temp(1));
        if ~isempty(routes{i, j})
            subRoute = routes{i, j};
            if length(subRoute) == 1
                % ��Ϊ����������ʱnodeCoor(1, 1)������ʹ��subRoute�����ÿһ����ΪnodeCoor������ʱ��Ӧ��+1
                % ���磺subRoute(1) = 3����ô����3����˿͵��Ӧ����nodeCoor(4, :)
                % ���ĳ����������·��ֻ��һ���㣬��ôֻ�û����������õ������·�����ɣ���ʵ����һ���ߣ�����ֻ���˴ӳ�������һ���˿͵㣩
                plot([nodeCoor(1, 1), nodeCoor(subRoute(1)+1, 1)], [nodeCoor(1, 2), nodeCoor(subRoute(1)+1, 2)], color)
                hold on
            else
                % ���������ӳ�������һ���˿͵��·��
                plot([nodeCoor(1, 1), nodeCoor(subRoute(1)+1, 1)], [nodeCoor(1, 2), nodeCoor(subRoute(1)+1, 2)], color)
                hold on
                % ���������һ���˿͵㵽������·��
                plot([nodeCoor(subRoute(end)+1, 1), nodeCoor(1, 1)], [nodeCoor(subRoute(end)+1, 2), nodeCoor(1, 2)], color)
                hold on
                % ���������ڹ˿͵�֮���·��
                for k = 1:length(subRoute)-1
                    plot([nodeCoor(subRoute(k)+1, 1), nodeCoor(subRoute(k+1)+1, 1)], [nodeCoor(subRoute(k)+1, 2), nodeCoor(subRoute(k+1)+1, 2)], color)
                    hold on
                end
            end
        end
    end
end

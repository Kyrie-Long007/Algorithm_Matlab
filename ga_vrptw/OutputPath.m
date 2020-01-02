function OutputPath(routes, subRouteCost, routesCost)
% ����Ļ�������·������Ӧ�ĳ��ȡ���·���ĳ��ȣ������һ������������壩
% ���룺������·������������·���ĳ��ȣ��������·���ĳ���
% �������·���Ͷ�Ӧ�ĳ��ȡ���·���ĳ���
%  ���ú�������

% ���ﲻ��ʹ��length(chrom)��һ��ʼ�����chrom��NIND*Nάʱ��length(chrom) = NIND
%������������chrom��һ�����壨����chrom(1, :)������ôlength(chrom) = N
for i = 1:size(routes, 1)
    for j = 1:size(routes, 2)
        % ������ж�������Ϊ�����·��ʱ������ "��4������·����"�������
        if ~isempty(routes{i, j})
            subRoute = routes{i, j};
            disp(['��', num2str(j), '������·����', num2str(subRoute)])
            disp(['    ��·��', num2str(j), '�ĳɱ���', num2str(subRouteCost{i, j})])
        else
            break
        end
    end
    % �����·��
    % ���ڲ�ͬ�ĸ��壬�Ի������������ֱ��
    disp(['��·���ɱ���', num2str(routesCost(i))])
    disp(' ')
end


%{
���ʾ����
>>OutputPath(demand, N, MAXLOAD, chrom(1:3, :));
��1������·����9  2  3
��2������·����10   1  11   8
��3������·����5  12   6   4
��4������·����7
 
��1������·����1  7  8
��2������·����10   9   4
��3������·����11   5  12   2   6
��4������·����3
 
��1������·����11  10   6
��2������·����4   5   8  12
��3������·����9  2  3  1  7
%}
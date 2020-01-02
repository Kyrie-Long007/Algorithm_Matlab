function chrom = Reverse(demand, N, MAXLOAD, NVEHICLE, M, dis, children)
% ������õ����Ӵ���Ⱥ��Ϊ��ת�ĸ�����Ⱥ����ת�����Ӵ���Ⱥ��̰��ԭ��ֻ���ܸ��õĽ⣩
% ���룺�˿͵��������Ⱦɫ�峤�ȣ��˿͵��������������������أ���ʹ�õ����������Υ�������Լ���ĳͷ����ӣ�������˿͵㡢�˿͵���˿͵�֮��ľ�����󣻸�����Ⱥ
% ���������ѭ�����Ӵ���Ⱥ����һ��ѭ���ĳ��Ը�����Ⱥ��
% ���ú�������

% �����Ӵ��ĸ����͸���ĳ���
[nChildren, L] = size(children);
% ������תǰ·�����ܳ���
routes = Decode(demand, N, MAXLOAD, children);
[~, routesLength] = CalLength(NVEHICLE, M, dis, routes);
% ��children��ֵ��reverseChildren
reverseChildren = children;
for i = 1:nChildren
    r1 = randsrc(1, 1, [1:L]);
    r2 = randsrc(1, 1, [1:L]);
    mininverse=min([r1, r2]);
    maxinverse=max([r1, r2]);
    reverseChildren(i, mininverse:maxinverse) = children(i, maxinverse:-1:mininverse);
end
reverseRoutes = Decode(demand, N, MAXLOAD, reverseChildren);
[~, reverseRoutesLength] = CalLength(NVEHICLE, M, dis, reverseRoutes);
% �ҳ���ת����õĽ������
index = reverseRoutesLength < routesLength;
children(index, :) = reverseChildren(index, :);
chrom = children;


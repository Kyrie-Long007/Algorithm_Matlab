function dis = Distance(nodeCoor, N)
% ���㳵����˿͵㡢�˿͵���˿͵�����֮��ľ���
% ���룺�����͹˿͵��λ�þ���Ⱦɫ��ĳ��ȣ��˿͵��������
% �����������˿͵㣨��һ�е�һ�У����˿͵���˿͵�ľ�����󣨵ڶ��е����һ�У��ڶ��е����һ�У�
% ���ú�������

dis = zeros(N+1, N+1);
for i = 1:N+1
    for j = i:N+1
        dis(i, j) = sqrt((nodeCoor(i, 1) - nodeCoor(j, 1))^2 + (nodeCoor(i, 2) - nodeCoor(j, 2))^2);
        dis(j, i) = dis(i, j);
    end
end
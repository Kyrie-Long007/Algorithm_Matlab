function children = Recombin(children, PC)
% ��ѡ��õ����Ӵ���Ⱥ��Ϊ����ĸ�����Ⱥ������һ���Ľ�����ʺͽ��涯�����������Ӵ���Ⱥ
% ���룺������Ⱥ��������
% ������Ӵ���Ⱥ
% ���ú�����Intercross

% �����Ӵ��ĸ���
nChildren = size(children, 1);
% ����ֱ�Ӱ�����nChildrenΪ������ż���������
% Ϊ��������1-2�� 3-4�� (nChildren-2)-(nChildren-1)��nChildren�����뽻��
% Ϊż������1-2�� 3-4�� (nChildren-1)-(nChildren)
for i = 1:2:nChildren - mod(nChildren, 2)
    % ��������ʴ��ڲ��������������н������
    if PC >= rand
        % ���淽ʽ�ܶ࣬����ʹ�����㽻�淽����ʹ�ú����ķ�ʽ�ĺô��Ǳ��ڸ���ѡ�񷽷�
        [children(i, :), children(i+1, :)] = Intercross(children(i, :), children(i+1, :));
        
    end
end

function [a, b] = Intercross(a, b)
% ���㽻�淨��ȫ���������ḻ��Ⱥ�Ķ����ԣ��ӿ���Ⱥ�������ԣ����ͽ���ǰ���бȽϣ�
% ���룺a, b������������ĸ�������
% �����a, b�������������֮����Ӵ�����
% ���ú�������

% ���㸸������ĳ���
L = length(a);
% ���ѡ����������λ��
r1 = randsrc(1, 1, [1:L]);
r2 = randsrc(1, 1, [1:L]);
if r1 ~= r2
    a0 = a;
    b0 = b;
    s = min([r1, r2]);
    e = max([r1, r2]);
    for i = s:e
        a1 = a;
        b1 = b;
        a(i) = b0(i);
        b(i) = a0(i);
        x = find(a==a(i));
        y=find(b==b(i));
        i1 = x(x~=i);
        i2 = y(y~=i);
        if ~isempty(i1)
            a(i1) = a1(i);
        end
        if ~isempty(i2)
            b(i2) = b1(i);
        end
    end
end  
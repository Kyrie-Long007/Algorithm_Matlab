function children = Mutate(children, PM)
% ������õ����Ӵ���Ⱥ��Ϊ����ĸ�����Ⱥ������һ���ı�����ʺͱ��춯�����������Ӵ���Ⱥ
% ���룺������Ⱥ��������
% ������Ӵ���Ⱥ
% ���ú�������

% �����Ӵ��ĸ����͸���ĳ���
[nChildren, L] = size(children);
% ����ÿһ�����壬��������ʴ������ɵ����������б������
for i = 1:nChildren
    if PM >= rand
        % ���ȡ���������λ��
        location = randperm(L);
        children(i, location(1:2)) = children(i, location(2:-1:1));
    end
end
function chrom = InitPop(NIND, N)
% ��ʼ��������Ⱥ
% ���룺��Ⱥ��ģ��Ⱦɫ��ĳ��ȣ��˿͵��������
% �����������Ⱥ
% ���ú�������

chrom = zeros(NIND, N);
for i = 1:NIND
    chrom(i, :) = randperm(N);
end
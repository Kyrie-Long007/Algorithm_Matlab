function children = Select(GGAP, chrom, fitness)
% ѡ�������Ӵ���Ⱥ��������Ⱥ�и���Ӳ��ֵ�ĸ����и���ĸ��ʱ���ѡ���Ӵ���
% ���룺�����ʣ�������Ⱥ��������Ⱥ��Ӧ����Ӧ��ֵ
% �����ѡ�������Ӵ���Ⱥ
% ���ú�����Rws�����̶�ѡ�񷨣�

% Ϊ�˺��潻����ڸ���������Ҫ��ѡ�������Ӵ���������Ҫ��2��
nChildren = max(floor(size(chrom, 1)*GGAP+0.5), 2);
% ѡ�������Ӵ��ڸ����е�������ѡ��ʽ�ܶ࣬����ʹ�����̶�ѡ�񷽷���ʹ�ú����ķ�ʽ�ĺô��Ǳ��ڸ���ѡ�񷽷���
[chrom, childrenIndex] = Rws(chrom, fitness, nChildren);
% ��������ѡ���Ӵ�
children = chrom(childrenIndex, :);

function [chrom, childrenIndex] = Rws(chrom, fitness, nChildren)
% ���̶�ѡ��ѡ���Ӵ��ڸ����е�������������Ӧ��ֵ�ߵĸ����и���ĸ��ʻᱻѡ���Ӵ���
% ���룺������Ⱥ��������Ⱥ��Ӧ����Ӧ��ֵ���Ӵ���Ⱥ������
% ��������������ĸ�����Ⱥ��ѡ�����Ӵ���Ⱥ�ڸ�����Ⱥ�е�����
% ���ú�������

% �Խ���ķ�ʽ����Ӧ��ֵ����
[sortFitness, index] = sort(fitness, 'descend');
% ͬʱ��ȺҲҪ����Ӧ��ֵ�Ӹߵ��͸���
chrom = chrom(index, :);
% ����������Ӧ��ֵ���й�һ��
normSortedFitness = sortFitness ./ sum(sortFitness);
% �Թ�һ�������Ӧ��ֵ�����ۼ�
cumNormFitness = cumsum(normSortedFitness);
% ����ֱ�����̶�ѡ��nChildren���Ӵ���������ѡ���͸���size(chrom, 1)����һ�����Ӵ�
% �ٶ��Ӵ�����Ӧ��ֵ������������ѡ��ǰ��nChildren��������Ӵ�
% һ��һ�������Ӵ����ڸ����е��������ȸ�childrenIndex��ֵ�վ��󣬱��ں������
childrenIndex = [];
% childrenIndex = zeros(size(chrom, 1), 1)
for i = 1:size(chrom, 1)
    % ���������
    generateRand = rand;
    % ������ɵ������Ϊ0�����������������
    while generateRand == 0
        generateRand = rand;
    end
    % find(cumNormFitness>generateRand, 1)�ҳ����ȳ������������һ�����壬1��find�����Сֵ��end��find������ֵ
    childrenIndex = [childrenIndex, find(cumNormFitness>generateRand, 1)];
end
% ��ѡ�����Ӵ��ڸ����е��������������������ڸ�������Ӧ��ֵ�ǽ��������������������ԽС������Ӧ��ֵԽ��
[sortChildIndex, ~] = sort(childrenIndex, 'ascend');
% ѡ��ǰnChildren���Ӵ�
childrenIndex = sortChildIndex(1:nChildren);%m(1:NSel)��NSel�������С�ģ�Ҳ������Ӧ��ֵ��õģ���Ϊ֮ǰ����Ӧ��ֵ���дӴ�С������
% ѡ��ǰnChildren������

        


















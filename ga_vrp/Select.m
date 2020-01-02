function children = Select(GGAP, chrom, fitness)
% 选择生成子代种群（父代种群中高适硬度值的个体有更大的概率被徐选入子代）
% 输入：代沟率；父代种群；父代种群对应的适应度值
% 输出：选择生成子代种群
% 调用函数：Rws（轮盘赌选择法）

% 为了后面交叉对于个体数量的要求，选出来的子代数量至少要有2个
nChildren = max(floor(size(chrom, 1)*GGAP+0.5), 2);
% 选出来的子代在父代中的索引（选择方式很多，这里使用轮盘赌选择方法，使用函数的方式的好处是便于更换选择方法）
[chrom, childrenIndex] = Rws(chrom, fitness, nChildren);
% 按照索引选出子代
children = chrom(childrenIndex, :);

function [chrom, childrenIndex] = Rws(chrom, fitness, nChildren)
% 轮盘赌选择法选出子代在父代中的索引（父代适应度值高的个体有更大的概率会被选入子代）
% 输入：父代种群；父代种群对应的适应度值；子代种群的数量
% 输出：降序排序后的父代种群；选出的子代种群在父代种群中的索引
% 调用函数：无

% 以降序的方式对适应度值排序
[sortFitness, index] = sort(fitness, 'descend');
% 同时种群也要按适应度值从高到低更新
chrom = chrom(index, :);
% 对排序后的适应度值进行归一化
normSortedFitness = sortFitness ./ sum(sortFitness);
% 对归一化后的适应度值进行累加
cumNormFitness = cumsum(normSortedFitness);
% 不是直接轮盘赌选出nChildren个子代，而是先选出和父代size(chrom, 1)数量一样的子代
% 再对子代的适应度值降序排序，优先选出前面nChildren个优秀的子代
% 一个一个生成子代的在父代中的索引，先给childrenIndex赋值空矩阵，便于后面添加
childrenIndex = [];
% childrenIndex = zeros(size(chrom, 1), 1)
for i = 1:size(chrom, 1)
    % 生成随机数
    generateRand = rand;
    % 如果生成的随机数为0，则重新生成随机数
    while generateRand == 0
        generateRand = rand;
    end
    % find(cumNormFitness>generateRand, 1)找出率先超过随机数的那一个个体，1求find后的最小值，end求find后的最大值
    childrenIndex = [childrenIndex, find(cumNormFitness>generateRand, 1)];
end
% 对选出的子代在父代中的索引进行升序排序，由于父代的适应度值是降序排序，所以这里的索引越小代表适应度值越高
[sortChildIndex, ~] = sort(childrenIndex, 'ascend');
% 选出前nChildren个子代
childrenIndex = sortChildIndex(1:nChildren);%m(1:NSel)是NSel个序号最小的，也就是适应度值最好的，因为之前给适应度值进行从大到小的排序
% 选择前nChildren个个体

        


















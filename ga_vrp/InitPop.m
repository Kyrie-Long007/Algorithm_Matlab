function chrom = InitPop(NIND, N)
% 初始化生成种群
% 输入：种群规模；染色体的长度（顾客点的数量）
% 输出：初代种群
% 调用函数：无

chrom = zeros(NIND, N);
for i = 1:NIND
    chrom(i, :) = randperm(N);
end
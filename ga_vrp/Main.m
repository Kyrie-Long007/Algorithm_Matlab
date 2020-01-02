% 编码规则
% 变量如果只有一个单词则小写，多个单词首单词小写，后面每个单词的首字母大写
% 常量单词全都大写
% 函数如果只有一个单词则首字母大写，多个单词每个单词的首字母大写
clear;
clc;
close all;
tic

NVEHICLE = 9;  % 可使用的最大车辆数
M = 1000;  % 违反最大车辆约束的惩罚因子 
MAXLOAD = 200;  % 车辆最大载重

%% 初始化参数（矩阵）

load data100;
data = data100;
nodeCoor = data(:, 1:2);
demand = data(:, 3);
timeWindow = data(:, 4:5);
serviceTime = data(:, 6);                   
                     
%% 初始化参数（常量）
NIND = 200;  % 种群大小 
N = size(nodeCoor, 1) - 1;  % 染色体的长度 （这里的长度要减去配送中心）
MAXGEN = 500;  % 最大终止代数
PC = 0.8;  % 交叉概率
PM = 0.1;  % 变异概率
GGAP = 1;  % 代沟(Generation gap)

%% 生成距离矩阵
dis = Distance(nodeCoor, N);     

%% 编码：初始化种群
chrom = InitPop(NIND, N);

%% 解码：得到解的路线（为避免重复计算，需要种群中的哪些个体全都在这里改）
routes = Decode(demand, N, MAXLOAD, chrom(1, :));

%% 计算这一代种群中每个个体的各条子路径长度和总长度
[subRouteLength, routesLength] = CalLength(NVEHICLE, M, dis, routes);

%% 在command window输出随机路径并画出随机路径的路径图，用于和后面优化后的路径比较
disp('初始种群中的一个随机解：');
OutputPath(routes, subRouteLength, routesLength);
DrawPath(nodeCoor, routes);

%% 优化
gen = 1;
% 记录每代最优值和平均值
% 这里不能写成zeros(NIND, 1)，那样当MAXGEN < NIND时，就会出现
% "最先出现最优值的代数永远是MAXGEN + 1代，并且最优值为0，因为optValPerGen(MAXGEN+1:NIND) = 0"
optValPerGen = zeros(MAXGEN, 1);
optMeanValPerGen = zeros(MAXGEN, 1);
% 记录每代最优的染色体
optIndPerGen = zeros(MAXGEN, N);
% gen的范围应该是[1, MAXGEN]
while gen <= MAXGEN
    % 查看进化代数
    disp(['gen：', num2str(gen)]);
    % 上面已经初始化种群了，这里不再重复操作，直接解码
    %初始化种群在第一代进行一次，循环时会自动调用chrom = Reins()里面的chrom，解码在计算路径长度和适应度在每一代都需要进行
    routes = Decode(demand, N, MAXLOAD, chrom);
    % 计算这一代种群中每个个体的各条子路径长度和总长度
    [~, routesLength] = CalLength(NVEHICLE, M, dis, routes);
    % 计算适应度
    fitness = Evaluate(routesLength);
    % 记录本代的最优值和平均值
    [minVal, minGen] = min(routesLength);
    optValPerGen(gen) = minVal;
    optMeanValPerGen(gen) = mean(routesLength);
    % 记录本代最优的染色体
    optIndPerGen(gen, :) = chrom(minGen, :);
   
    %% 遗传操作
    % 选择
    children = Select(GGAP, chrom, fitness);
    % 交叉
    children = Recombin(children, PC);
    % 变异
    children = Mutate(children, PM);
    % 逆转
    chrom = Reverse(demand, N, MAXLOAD, NVEHICLE, M, dis, children);
    % 重插入子代的新种群
%     chrom=Reins(chrom,SelCh,ObjV);
    % 更新代数
     gen = gen+1;
end

% 画出每代最优值和每代平均值曲线
figure
plot(optValPerGen, 'r-')
hold on
plot(optMeanValPerGen, 'b-.')
legend('最优值', ' 平均值')
xlabel('代数')
ylabel('路径长度')

%% 得出最优路径图
% 找出每代最优值变量中的最小值以及对应的索引
[minVal, minGen] = min(optValPerGen);
% 输出解，画出路径图
routes = Decode(demand, N, MAXLOAD, optIndPerGen(minGen, :));
[subRouteLength, routesLength] = CalLength(NVEHICLE, M, dis, routes);
disp(['在第', num2str(minGen), '代最先得到最优解：'])
OutputPath(routes, subRouteLength, routesLength);
DrawPath(nodeCoor, routes);
toc
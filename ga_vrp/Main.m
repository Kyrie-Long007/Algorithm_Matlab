% �������
% �������ֻ��һ��������Сд����������׵���Сд������ÿ�����ʵ�����ĸ��д
% ��������ȫ����д
% �������ֻ��һ������������ĸ��д���������ÿ�����ʵ�����ĸ��д
clear;
clc;
close all;
tic

NVEHICLE = 9;  % ��ʹ�õ��������
M = 1000;  % Υ�������Լ���ĳͷ����� 
MAXLOAD = 200;  % �����������

%% ��ʼ������������

load data100;
data = data100;
nodeCoor = data(:, 1:2);
demand = data(:, 3);
timeWindow = data(:, 4:5);
serviceTime = data(:, 6);                   
                     
%% ��ʼ��������������
NIND = 200;  % ��Ⱥ��С 
N = size(nodeCoor, 1) - 1;  % Ⱦɫ��ĳ��� ������ĳ���Ҫ��ȥ�������ģ�
MAXGEN = 500;  % �����ֹ����
PC = 0.8;  % �������
PM = 0.1;  % �������
GGAP = 1;  % ����(Generation gap)

%% ���ɾ������
dis = Distance(nodeCoor, N);     

%% ���룺��ʼ����Ⱥ
chrom = InitPop(NIND, N);

%% ���룺�õ����·�ߣ�Ϊ�����ظ����㣬��Ҫ��Ⱥ�е���Щ����ȫ��������ģ�
routes = Decode(demand, N, MAXLOAD, chrom(1, :));

%% ������һ����Ⱥ��ÿ������ĸ�����·�����Ⱥ��ܳ���
[subRouteLength, routesLength] = CalLength(NVEHICLE, M, dis, routes);

%% ��command window������·�����������·����·��ͼ�����ںͺ����Ż����·���Ƚ�
disp('��ʼ��Ⱥ�е�һ������⣺');
OutputPath(routes, subRouteLength, routesLength);
DrawPath(nodeCoor, routes);

%% �Ż�
gen = 1;
% ��¼ÿ������ֵ��ƽ��ֵ
% ���ﲻ��д��zeros(NIND, 1)��������MAXGEN < NINDʱ���ͻ����
% "���ȳ�������ֵ�Ĵ�����Զ��MAXGEN + 1������������ֵΪ0����ΪoptValPerGen(MAXGEN+1:NIND) = 0"
optValPerGen = zeros(MAXGEN, 1);
optMeanValPerGen = zeros(MAXGEN, 1);
% ��¼ÿ�����ŵ�Ⱦɫ��
optIndPerGen = zeros(MAXGEN, N);
% gen�ķ�ΧӦ����[1, MAXGEN]
while gen <= MAXGEN
    % �鿴��������
    disp(['gen��', num2str(gen)]);
    % �����Ѿ���ʼ����Ⱥ�ˣ����ﲻ���ظ�������ֱ�ӽ���
    %��ʼ����Ⱥ�ڵ�һ������һ�Σ�ѭ��ʱ���Զ�����chrom = Reins()�����chrom�������ڼ���·�����Ⱥ���Ӧ����ÿһ������Ҫ����
    routes = Decode(demand, N, MAXLOAD, chrom);
    % ������һ����Ⱥ��ÿ������ĸ�����·�����Ⱥ��ܳ���
    [~, routesLength] = CalLength(NVEHICLE, M, dis, routes);
    % ������Ӧ��
    fitness = Evaluate(routesLength);
    % ��¼����������ֵ��ƽ��ֵ
    [minVal, minGen] = min(routesLength);
    optValPerGen(gen) = minVal;
    optMeanValPerGen(gen) = mean(routesLength);
    % ��¼�������ŵ�Ⱦɫ��
    optIndPerGen(gen, :) = chrom(minGen, :);
   
    %% �Ŵ�����
    % ѡ��
    children = Select(GGAP, chrom, fitness);
    % ����
    children = Recombin(children, PC);
    % ����
    children = Mutate(children, PM);
    % ��ת
    chrom = Reverse(demand, N, MAXLOAD, NVEHICLE, M, dis, children);
    % �ز����Ӵ�������Ⱥ
%     chrom=Reins(chrom,SelCh,ObjV);
    % ���´���
     gen = gen+1;
end

% ����ÿ������ֵ��ÿ��ƽ��ֵ����
figure
plot(optValPerGen, 'r-')
hold on
plot(optMeanValPerGen, 'b-.')
legend('����ֵ', ' ƽ��ֵ')
xlabel('����')
ylabel('·������')

%% �ó�����·��ͼ
% �ҳ�ÿ������ֵ�����е���Сֵ�Լ���Ӧ������
[minVal, minGen] = min(optValPerGen);
% ����⣬����·��ͼ
routes = Decode(demand, N, MAXLOAD, optIndPerGen(minGen, :));
[subRouteLength, routesLength] = CalLength(NVEHICLE, M, dis, routes);
disp(['�ڵ�', num2str(minGen), '�����ȵõ����Ž⣺'])
OutputPath(routes, subRouteLength, routesLength);
DrawPath(nodeCoor, routes);
toc
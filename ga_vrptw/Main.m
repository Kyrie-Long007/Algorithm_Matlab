% �������
% �������ֻ��һ��������Сд����������׵���Сд������ÿ�����ʵ�����ĸ��д
% ��������ȫ����д
% �������ֻ��һ������������ĸ��д���������ÿ�����ʵ�����ĸ��д
clear;
clc;
close all;
tic

%% ��ʼ������������

% �������Ҫ�����Լ�������԰�NVEHICLE���һ������������
NVEHICLE = 3;  % ��ʹ�õ��������
% M���������������ɣ�Զ���ڿ��н��ֵ���У�
M = 2000;  % Υ�������Լ���ĳͷ����� 
MAXLOAD = 15;  % �����������

load data12;
data = data12;
nodeCoor = data(:, 1:2);
demand = data(:, 3);
timeWindow = data(:, 4:5);
serviceTime = data(:, 6);

%{
nodeCoor = [15,12;
                     3,13;
                     3,17;
                     6,18;
                     8,17;
                     10,14;
                     14,13;
                     15,11;
                     15,15;
                     17,11;
                     17,16;
                     18,19;
                     19,9;
                     19,21;
                     21,22;
                     23,9;
                     23,22;
                     24,11;
                     27,21;
                     26,6;
                     26,9;
                     27,2;
                     27,4;
                     27,17;
                     28,7;
                     29,14;
                     29,18;
                     30,1;
                     30,8;
                     30,15;
                     30,17];
demand = [0, 50,50,60,30,90,10,20,10,30,20,30,10,10,10,40,51,20,20,20,30,30,30,10,60,30,20,30,40,20,20];
%}                     
                     
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

%% ������һ����Ⱥ��ÿ������ĸ�����·���ɱ����ܳɱ�
[subRouteCost, routesCost] = CalCost(NVEHICLE, M, dis, timeWindow, serviceTime, routes);

%% ��command window������·�����������·����·��ͼ�����ںͺ����Ż����·���Ƚ�
disp('��ʼ��Ⱥ�е�һ������⣺');
OutputPath(routes, subRouteCost, routesCost);
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
    % ������һ����Ⱥ��ÿ������ĸ�����·���ɱ����ܳɱ�
    [~, routesCost] = CalCost(NVEHICLE, M, dis, timeWindow, serviceTime, routes);
    % ������Ӧ��
    fitness = Evaluate(routesCost);
    % ��¼����������ֵ��ƽ��ֵ
    [minVal, minGen] = min(routesCost);
    optValPerGen(gen) = minVal;
    optMeanValPerGen(gen) = mean(routesCost);
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
    chrom = Reverse(NVEHICLE, M, MAXLOAD, demand, N, dis, timeWindow, serviceTime, children);
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
ylabel('·���ɱ�')

%% �ó�����·��ͼ
% �ҳ�ÿ������ֵ�����е���Сֵ�Լ���Ӧ������
[minVal, minGen] = min(optValPerGen);
% ����⣬����·��ͼ
routes = Decode(demand, N, MAXLOAD, optIndPerGen(minGen, :));
[subRouteCost, routesCost] = CalCost(NVEHICLE, M, dis, timeWindow, serviceTime, routes);
disp(['�ڵ�', num2str(minGen), '�����ȵõ����Ž⣺'])
OutputPath(routes, subRouteCost, routesCost);
DrawPath(nodeCoor, routes);
toc
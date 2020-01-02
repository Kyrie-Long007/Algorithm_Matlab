function fitness = Evaluate(routesCost)
% 评价种群中个体的适应度值
% 输入：总路径的长度
% 输出：适应度值
% 调用函数：无

fitness = 1 ./ routesCost;
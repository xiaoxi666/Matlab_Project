%Filename：      transfucTopara.m
%Author:        HC
%Date:          2016/9/8
%Description:   给定任意传递函数，输出其响应各种参数,暂定为阶跃响应
%               函数调用格式：[sys]=transfucTopara(num,den,gTolerance)，
%               其中sys为传递函数表示
%Input:         
%               num:传递函数分子系数，矩阵形式
%               den:传递函数分母系数，矩阵形式
%               gTolerance:调整时间的稳态误差，一般为2%或5%，请输入小数形式
%Output:
%               时域响应图
%               系统稳定性与否判断
%               特征根
%               上升时间，浮点数（图中以红色竖线表示）
%               峰值时间，浮点数（图中以绿色竖线表示）
%               调整时间，浮点数（图中以黄色竖线表示）
%               峰值，浮点数
%               稳态值，浮点数
%               超调量，以百分数表示
%Version:1.0.0

function [sys,p,tr,peakValue,tp,finalValue,overshoot,ts]=transfucTopara(num,den,gTolerance)
%输入传递函数的分子系数矩阵和分母系数矩阵
%cofficient是系数英文,
%characteristicroot为特征根
%gTolerance为2%或5%，稳态误差
    sys=tf(num,den)  %传递函数
    step(sys);%画图
    grid;
    hold on;
    
    p=roots(den);%打印特征根
    %此处首先判断传递函数的稳定性，若不稳定，则终止分析
    ss=find(real(p)>0, 1);%这里的1是系统修正的，为了提高性能，没看什么意思。
    if ~isempty(ss)
        disp('系统不稳定，终止分析。');
    else
        disp('系统稳定，分析结果如下：');  
        [y,t]=step(sys);%提供数据
        [peakValue,k]=max(y);%峰值
        tp=spline(y,t,peakValue);%峰值时间（插值算法）
        %tp1=t(k);%注意峰值时间也可这样求（取出t序列【即时间系列】对应峰值的时间，这里用到临时变量k）

        finalValue=polyval(num,0)/polyval(den,0);%算出稳态值
        %finalValue1=dcgain(sys);%稳态值也可以这样求,dcgain即为系统增益，也就是系统稳态值
        overshoot=100*(peakValue-finalValue)/finalValue;%超调量(百分数形式)

        n=1;
        while y(n)<finalValue
            n=n+1;
        end
        tr=t(n);%上升时间

        i=length(t);
        while (y(i)>(1-gTolerance)*finalValue)&&(y(i)<(1+gTolerance)*finalValue)
            i=i-1;
        end
        ts=t(i);%调整时间

        %plot(tp,peakValue,'--s','LineWidth',2,'MarkerEdgeColor','k','MarkerEdgeColor','r','MarkerSize',5);

        stem(tr,finalValue,'r');
        stem(tp,peakValue,'g');
        plot([ts ts], get(gca, 'YLim'), '-y', 'LineWidth', 1) %画一条竖线，表示调整时间。此处为红色，宽度为1   
        
        %集中输出数据：
        fprintf('特征根  ：\n');
        disp(p);
        fprintf('上升时间：%f\n',tr);
        fprintf('峰值时间：%f\n',tp);
        fprintf('调整时间：%f\n',ts);
        fprintf('峰值    ：%f\n',peakValue);
        fprintf('稳态值  ：%f\n',finalValue);
        fprintf('超调量  ：%f%%\n',overshoot);
        
    end
end
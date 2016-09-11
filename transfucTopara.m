%Filename��      transfucTopara.m
%Author:        HC
%Date:          2016/9/8
%Description:   �������⴫�ݺ������������Ӧ���ֲ���,�ݶ�Ϊ��Ծ��Ӧ
%               �������ø�ʽ��[sys]=transfucTopara(num,den,gTolerance)��
%               ����sysΪ���ݺ�����ʾ
%Input:         
%               num:���ݺ�������ϵ����������ʽ
%               den:���ݺ�����ĸϵ����������ʽ
%               gTolerance:����ʱ�����̬��һ��Ϊ2%��5%��������С����ʽ
%Output:
%               ʱ����Ӧͼ
%               ϵͳ�ȶ�������ж�
%               ������
%               ����ʱ�䣬��������ͼ���Ժ�ɫ���߱�ʾ��
%               ��ֵʱ�䣬��������ͼ������ɫ���߱�ʾ��
%               ����ʱ�䣬��������ͼ���Ի�ɫ���߱�ʾ��
%               ��ֵ��������
%               ��ֵ̬��������
%               ���������԰ٷ�����ʾ
%Version:1.0.0

function [sys,p,tr,peakValue,tp,finalValue,overshoot,ts]=transfucTopara(num,den,gTolerance)
%���봫�ݺ����ķ���ϵ������ͷ�ĸϵ������
%cofficient��ϵ��Ӣ��,
%characteristicrootΪ������
%gToleranceΪ2%��5%����̬���
    sys=tf(num,den)  %���ݺ���
    step(sys);%��ͼ
    grid;
    hold on;
    
    p=roots(den);%��ӡ������
    %�˴������жϴ��ݺ������ȶ��ԣ������ȶ�������ֹ����
    ss=find(real(p)>0, 1);%�����1��ϵͳ�����ģ�Ϊ��������ܣ�û��ʲô��˼��
    if ~isempty(ss)
        disp('ϵͳ���ȶ�����ֹ������');
    else
        disp('ϵͳ�ȶ�������������£�');  
        [y,t]=step(sys);%�ṩ����
        [peakValue,k]=max(y);%��ֵ
        tp=spline(y,t,peakValue);%��ֵʱ�䣨��ֵ�㷨��
        %tp1=t(k);%ע���ֵʱ��Ҳ��������ȡ��t���С���ʱ��ϵ�С���Ӧ��ֵ��ʱ�䣬�����õ���ʱ����k��

        finalValue=polyval(num,0)/polyval(den,0);%�����ֵ̬
        %finalValue1=dcgain(sys);%��ֵ̬Ҳ����������,dcgain��Ϊϵͳ���棬Ҳ����ϵͳ��ֵ̬
        overshoot=100*(peakValue-finalValue)/finalValue;%������(�ٷ�����ʽ)

        n=1;
        while y(n)<finalValue
            n=n+1;
        end
        tr=t(n);%����ʱ��

        i=length(t);
        while (y(i)>(1-gTolerance)*finalValue)&&(y(i)<(1+gTolerance)*finalValue)
            i=i-1;
        end
        ts=t(i);%����ʱ��

        %plot(tp,peakValue,'--s','LineWidth',2,'MarkerEdgeColor','k','MarkerEdgeColor','r','MarkerSize',5);

        stem(tr,finalValue,'r');
        stem(tp,peakValue,'g');
        plot([ts ts], get(gca, 'YLim'), '-y', 'LineWidth', 1) %��һ�����ߣ���ʾ����ʱ�䡣�˴�Ϊ��ɫ�����Ϊ1   
        
        %����������ݣ�
        fprintf('������  ��\n');
        disp(p);
        fprintf('����ʱ�䣺%f\n',tr);
        fprintf('��ֵʱ�䣺%f\n',tp);
        fprintf('����ʱ�䣺%f\n',ts);
        fprintf('��ֵ    ��%f\n',peakValue);
        fprintf('��ֵ̬  ��%f\n',finalValue);
        fprintf('������  ��%f%%\n',overshoot);
        
    end
end
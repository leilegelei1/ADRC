function [sys,x0,str,ts]=han_ctrl(t,x,u,flag,aa,bet1,b,d)
switch flag,
case 0
   [sys,x0,str,ts] = mdlInitializeSizes(t,u,x); % ��ʼ��
case 3
   sys = mdlOutputs(t,x,u,aa,bet1,b,d); % ������ļ���
case { 1,2,4,9 }
   sys = []; % δʹ�õ�flagֵ
otherwise
   error(['Unhandled flag = ',num2str(flag)]); % �������
end;
%==============================================================
% ��flagΪ0ʱ�������ϵͳ�ĳ�ʼ��
%==============================================================
function [sys,x0,str,ts] = mdlInitializeSizes(t,u,x)
% ���ȵ���simsizes����ó�ϵͳ��ģ����sizes, �������ɢϵͳ��ʵ��
% �������sizes����
sizes = simsizes;
sizes.NumContStates = 0; % ����״̬��Ϊ0
sizes.NumDiscStates = 0; % ��ɢ״̬��Ϊ0
sizes.NumOutputs = 1;    % ���·��Ϊ1
sizes.NumInputs = 5;     % ����·��Ϊ5
sizes.DirFeedthrough = 1;% �����������ֱ����ʾ������ע�ⲻ�ܽ�������Ϊ0
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0 = []; % ���ó�ʼ״̬Ϊ��״̬
str = []; % ��str��������Ϊ���ַ�
ts = [-1 0]; % ��������: [period, offset]
%==============================================================
% ��������flag=3ʱ������ϵͳ���������
%==============================================================
function sys = mdlOutputs(t,x,u,aa,bet1,b,d)
e1=u(1)-u(3); e2=u(2)-u(4); 
u0=bet1(1)*fal(e1,aa(1),d)+bet1(2)*fal(e2,aa(2),d);%pid的非线性组合
sys=u0-u(5)/b;
%==============================================================
% �û�������Ӻ��� fal
%==============================================================
function f=fal(e,a,d)
if abs(e)<d
   f=e*d^(a-1);
else
   f=(abs(e))^a*sign(e);
end

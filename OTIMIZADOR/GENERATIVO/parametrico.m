%% GRAMÁTICA DE FORMA SIMPLIFICADA 
function [coord,mat,elem,L]=parametrico(x) 
global Lf t l_log node E
%% Tipo de Seção (Atenção nas possíveis discordâncias)
%
Ctr=0;  %Omega
Rv=0;   %Rack
CorZ=1; %Ze=2|Ue=1

%% Parâmetros
bf=x(1);                %DIMENSÃO 1
b1=bf;b2=bf;            %BF=MESA
%-----------------------------
D=x(2);                 %%DIMENSÃO 2
d1=D;d2=D;              %D=ENRIJECEDOR
%-----------------------------
bw=Lf-2.*D-2.*bf;  %RELAÇÃO LINEAR   

if bw<=0
    bw=bf;
end
h=bw;                   %BW=ALMA
%-----------------------------
q1=x(3);q2=q1;          %THETA=ÂNGULOS DOS INREJECDORES
%-----------------------------
r1=3;r2=r1;r3=r1;r4=r1; %RAIOS DE CONFORMAÇÃO
%-----------------------------
bs=25;                  %BS=ABA DO RACK
%% Gramática de forma
[node,elem,springs,constraints,geom,cz]=...
geometria(CorZ,h,b1,b2,d1,d2,r1,r2,r3,r4,q1,q2,t,bs,Ctr,Rv);
coord=node(:,1:4);
mat=[100 E E 0.3 0.3];
%Comprimentos
L=logspace(1,l_log,200);

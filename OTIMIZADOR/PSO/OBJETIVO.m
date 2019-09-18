%% Fun��o Aptid�o NCRK
function out=OBJETIVO(x)
global Verificador cont
%% TORNAR VETOR DE VARI�VEIS EM PAR�METROS GEOM�TRICOS
[coord,mat,elem,L]=parametrico(x); 
%% RESIST�NCIA
%%Compress�o

 [~,plot_ass]=faixas(coord,elem,mat,L);        %MFF|Saida em tens�o
 [Ncrk1,~,~,~]=MRDN (plot_ass,coord,elem);      %MRD DA NORMA (kN)
%[Ncrk2,~,~]=INT_L_D (x,plot_ass,coord,elem);  %PELA INTERA��O L-D|MATSUBARA  (kN)
 

%%Flex�o simples

% [coord]=gerten(coord,elem);             %Gerar tens�o de flex�o uniforme
% [~,plot_ass]=faixas(coord,elem,mat,L);  %MFF|Saida em tens�o
% [Mcrk]=MRDM (plot_ass,coord,elem);      %MRD DA NORMA (kN.mm)

%Compara��o

%Compress�o
% Comp=max(L);
% Verificador(cont+1,:)=[Comp Ncrk1 Ncrk2];

%Flex�o
% Verificador(cont+1,:)=[Comp Mcrk];

%% FUN��O OBJETIVO - CARGA CR�TICA
% Flambagem=min(plot_ass(1,:));                %Curva de assinatura em tens�o 
% out=Flambagem*(t*Lf);                        %Tens�o x �rea = Carga 

%% FUN��O OBJETIVO - RESIST�NCIA

%Compress�o
% Ncrk=min([Ncrk1 Ncrk2]);
Ncrk=Ncrk1;
out=Ncrk;

%Flex�o simples
%  Mcrk=min([Mcrk]);
%  out=Mcrk;
%% FUN��O OBJETIVO- EROS�O FOR�ADA 
%Na compress�o 
% Erosao=Ncrk1-Ncrk2;
% out=Erosao;





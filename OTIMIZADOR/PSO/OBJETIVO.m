%% Função Aptidão NCRK
function out=OBJETIVO(x)
global Verificador cont
%% TORNAR VETOR DE VARIÁVEIS EM PARÂMETROS GEOMÉTRICOS
[coord,mat,elem,L]=parametrico(x); 
%% RESISTÊNCIA
%%Compressão

 [~,plot_ass]=faixas(coord,elem,mat,L);        %MFF|Saida em tensão
 [Ncrk1,~,~,~]=MRDN (plot_ass,coord,elem);      %MRD DA NORMA (kN)
%[Ncrk2,~,~]=INT_L_D (x,plot_ass,coord,elem);  %PELA INTERAÇÃO L-D|MATSUBARA  (kN)
 

%%Flexão simples

% [coord]=gerten(coord,elem);             %Gerar tensão de flexão uniforme
% [~,plot_ass]=faixas(coord,elem,mat,L);  %MFF|Saida em tensão
% [Mcrk]=MRDM (plot_ass,coord,elem);      %MRD DA NORMA (kN.mm)

%Comparação

%Compressão
% Comp=max(L);
% Verificador(cont+1,:)=[Comp Ncrk1 Ncrk2];

%Flexão
% Verificador(cont+1,:)=[Comp Mcrk];

%% FUNÇÃO OBJETIVO - CARGA CRÍTICA
% Flambagem=min(plot_ass(1,:));                %Curva de assinatura em tensão 
% out=Flambagem*(t*Lf);                        %Tensão x Área = Carga 

%% FUNÇÃO OBJETIVO - RESISTÊNCIA

%Compressão
% Ncrk=min([Ncrk1 Ncrk2]);
Ncrk=Ncrk1;
out=Ncrk;

%Flexão simples
%  Mcrk=min([Mcrk]);
%  out=Mcrk;
%% FUNÇÃO OBJETIVO- EROSÃO FORÇADA 
%Na compressão 
% Erosao=Ncrk1-Ncrk2;
% out=Erosao;





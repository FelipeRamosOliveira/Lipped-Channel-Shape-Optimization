function [Ncrk,LambdaG]=MRDN (plot_ass,coord,elem)
%% CÁLCULO DE RESISTÊNCIA À COMPRESSÃO CENTRADA (MRD)
%Propriedades geométricas e do material 
global fy E L
%% 1.PROPRIEDADES
%Geometricas
[b,A,xg,yg,J,Ixg,Iyg,Ixyg,teta,I11,I22,xc,yc,wc,Cw,x0,y0,r0,WxC,WyC] = prop_geom_PFF(coord,elem); %JOÃO 

%Material
v=0.3;
G =E./(2.*(1+v));   %kN/mm2

%Transforma curvade assinatura de tensão (E=kN/mm2) para força (Pcr=kN)
Assinatura=plot_ass(1,:).*A; 
%% 2.RESISTÊNCIA À FLAMBAGEM GLOBAL 
[Ncre,Nex,Ney,Nez,Nexz,Neyz,Ne,LambdaG]=NCRE(L,E,I11,I22,r0,x0,y0,Cw,G,J,A,fy);


%% 3. CLASSIFICAR OS TIPOS DE FLAMBAGEM
%Vetor cargas crítcas
Pcr=Assinatura;
%Classificador não elgante

%
Minimos = [islocalmin(Assinatura).*Assinatura]';
Minimos =[nonzeros(Minimos)];
%
if isempty(Minimos)
Nl=Ne;
Nd=Ne;
else
Nl=Minimos(1);
end
%
if length(Minimos)>=2
    Nd=min(Minimos(2:length(Minimos)));
else
    Nd=5.*Nl;
end
%
%% 4.RESISTÊNCIA À FLAMBAGEM LOCAL
[Ncrl,LambdaL]=NCRL(Ncre,Nl);
%
%% 5.RESISTÊNCIA À FLAMBAGEM DISTORCIONAL
[Ncrd,LambdaD]=NCRD(A,fy,Nd);

%% 6.RESISTÊNCIA CARCTERISTICA
LambdaMax=max(LambdaL,LambdaD);
if LambdaMax<2.55
Ncrk=min([Ncre Ncrl Ncrd]);
else
Ncrk=0.2*min([Ncre Ncrl Ncrd]);
end

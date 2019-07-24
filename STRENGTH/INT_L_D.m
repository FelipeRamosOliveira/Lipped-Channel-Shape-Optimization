%C�CULO DE RESIST�NCIA CONSIDERANDO A INTERA��O L/D
%Gustavo Y. Matsubara, Eduardo de M. Batista, Guilherme C.  Salles
function [Ncrk,LambdaL,LambdaD]=INT_L_D (x,plot_ass,coord,elem);
%% PR� PROCESSAMENTO
%Propiedades da se��o e material 
global fy Lf
[b,Area,xg,yg,J,Ixg,Iyg,Ixyg,teta,I11,I22,xc,yc,wc,Cw,x0,y0,r0,WxC,WyC] = prop_geom_PFF(coord,elem);

bf=x(1);
bs=x(2);
bw=Lf-2*bf-2*bs;
%--------------------------------------------------------------

%Transformar a curva de assinatura de tens�o pra for�a
Assinatura=plot_ass(1,:).*Area; %kN    
Py=Area.*fy;                    %Tens�o de escoamento 

%Encontrar os m�nimos 
%Classificador n�o elgante
%
Minimos = [islocalmin(Assinatura).*Assinatura]';
Minimos =[nonzeros(Minimos)];
Ne=min(Assinatura);
%
if isempty(Minimos)
Pl=Ne;
Pd=Ne;
else
    Pl=Minimos(1);
end
%
if length(Minimos)>=2
    Pd=min(Minimos(2:length(Minimos)));
else
    Pd=1.2.*Pl;
end
%

%% C�CULO DE RESIST�NCIA (Superfice unica)
%Esbeltez e raz�o D/L
LambdaL=(Py./Pl).^0.5;
LambdaD=(Py./Pd).^0.5;
LambdaMAX=max(LambdaL,LambdaD);
Rdl=LambdaD/LambdaL;

 if bf/bw<0.65
%------------------------------------------------
%Primeiro Par de equa��es 
%Par�metro A
if Rdl < 0.8,       A=0.15;
elseif Rdl<1.1,     A=(-7.79.*Rdl.^3)+(22.48.*Rdl.^2)+(-21.1.*Rdl)+6.62;
else,               A=0.25;
end
%Par�metro B+4+4
if Rdl < 0.55,      B=0.80;
elseif Rdl<1.05,    B=(-12.86.*Rdl.^3)+(27.17.*Rdl.^2)+(-17.03.*Rdl)+4;
else,               B=1.20;
end
%--------------------------------------------------------------
 else bf/bw>=0.65;
%--------------------------------------------------------------     
%Segundo par de equa��es 
%Par�metro A
if Rdl < 0.6,       A=0.15;
elseif Rdl<=1.0,    A=(1.89.*Rdl.^3)+(-4.09.*Rdl.^2)+(3.1.*Rdl)-0.65;
else,               A=0.25;
end
%Par�metro B
if Rdl < 0.25,      B=0.80;
elseif Rdl<1.20,    B=(-2.28.*Rdl.^3)+(3.65.*Rdl.^2)+(-0.78.*Rdl)+0.8;
else,               B=1.20;
end
%-------------------------------------------------------------- 
end  
%Curva de Winter 
Prdl=(1-(A./LambdaMAX.^B)).*(Py./(LambdaMAX.^B));
%-----------------------------------------------------
Ncrk=Prdl;





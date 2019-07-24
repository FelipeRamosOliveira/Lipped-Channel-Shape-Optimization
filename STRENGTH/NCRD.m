function [Ncrd,LambdaD]=NCRD(A,fy,Nd)
for i=1:length(Nd)
%Esbeltez � flambagem distorcional
LambdaD(i)=(A.*fy./Nd(i)).^0.5;
%Resist�ncia carcteristica � flambagem distorcional
    if LambdaD(i)<=0.561;
        Ncrd(i)=A.*fy;
  else LambdaD(i)>0.561;   
        Ncrd(i)=(1-0.25./(LambdaD(i).^1.2)).*(A.*fy./(LambdaD(i).^1.2));
    end
end
Ncrd=Ncrd';
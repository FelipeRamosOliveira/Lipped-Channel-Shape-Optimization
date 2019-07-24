function [node,elem,springs,constraints,geom,cz]=...
          gramatica(CorZ,h,b1,b2,d1,d2,r1,r2,r3,r4,q1,q2,t,bs,Ctr,Rv)
%% ROTINA GENERATIVA(VERSÃO SIMPLIFICADA)

% Modificação R05-28/04/19
%As versões com cantos curvos dos seguintes perfis estão devidamente 
%descritas na versão full do programa 

%CorZ -> determina se o pefil é U/OMEGA ou Z 
if CorZ==2,cz=-1;,else,cz=1;,end
if Rv==1,cz=1;,end
%
%Coverte graus em radianos
q1=q1*pi/180;
q2=q2*pi/180;
%---------------------------------------------------------------------------------
%% SEÇÃO Ue e Ze 
%
%Cantos semi-angulares        
%        geom=[1 r1+b1+r2*cos(pi/2-q1)+d1*cos(q1)        r2-r2*sin(pi/2-q1)+d1*sin(q1)
%             2 r1+b1+r2*cos(pi/2-q1)                     r2-r2*sin(pi/2-q1)
%             3 r1+b1                                     0
%             4 r1                                        0
%             5 0                                         r1
%             6 0                                         r1+h
%             7 cz*r3                                     r1+h+r3
%             8 cz*(r3+b2)                                r1+h+r3
%             9 cz*(r3+b2+r4*cos(pi/2-q2))                r1+h+r3-r4+r4*sin(pi/2-q2)
%             10 cz*(r3+b2+r4*cos(pi/2-q2)+d2*cos(q2))    r1+h+r3-r4+r4*sin(pi/2-q2)-d2*sin(q2)];
%
%Cantos totalmennte retos     
        geom=[ 1    b1+d1*cos(q1)                   d1*sin(q1)
               2    b1+(d1/2)*cos(q1)              (d1/2)*sin(q1)
               3    b1                              0
               4    b1*(3/4)                        0
               5    b1*(1/2)                        0
               6    b1*(1/4)                        0
               7    0                               0
               8    0                               h*(1/4)
               9    0                               h*(1/2)
               10   0                               h*(3/4)
               11   0                               h
               12   cz*b2*(1/4)                        h
               13   cz*b2*(1/2)                        h
               14   cz*b2*(3/4)                        h
               15   cz*b2                              h
               16   cz*(b2+(d2/2)*cos(q2))          h-(d2/2)*sin(q2)
               17   cz*(b2+d2*cos(q2))              h-d2*sin(q2)      ];
%             
for i=1:length(geom)
   node(i,:)=[geom(i,1) geom(i,2) geom(i,3) 1 1 1 1 1.0];    
end
%
%---------------------------------------------------------------------------------
%% OMEGA 
if Ctr==1
%
%Cantos semi-angulares 
%
%         geom=[  1  r1+b1+r2*cos(pi/2-q1)+d1*cos(q1)       -r2-r2*sin(pi/2-q1)-d1*sin(q1)
%                 2  r1+b1+r2*cos(pi/2-q1)                  -r2-r2*sin(pi/2-q1)
%                 3  r1+b1                                   0
%                 4  r1                                      0
%                 5  0                                       r1
%                 6  0                                       r1+h
%                 7  r3                                      r1+h+r3
%                 8  r3+b2                                   r1+h+r3
%                 9  r3+b2+r4*cos(pi/2-q2)                   r1+h+r3+r4+r4*sin(pi/2-q2)
% 
%                 10 r3+b2+r4*cos(pi/2-q2)+d2*cos(q2)        r1+h+r3+r4+r4*sin(pi/2-q2)+d2*sin(q2)];
%
%Cantos totalmennte retos   
%
        geom=[ 1    b1+d1*cos(q1)           -d1*sin(q1)
               2    b1+(d1/2)*cos(q1)       -(d1/2)*sin(q1)
               3    b1                      0
               4    b1*(3/4)                0
               5    b1*(1/2)                0
               6    b1*(1/4)                0
               7    0                       0
               8    0                       h*(1/4)
               9    0                       h*(1/2)
               10   0                       h*(3/4)
               11   0                       h
               12   b2*(1/4)                h
               13   b2*(1/2)                h
               14   b2*(3/4)                h
               15   b2                      h
               16   b2+(d2/2)*cos(q2)       h+(d2/2)*sin(q2)
               17   b2+d2*cos(q2)           h+d2*sin(q2)      ];
%             
for i=1:length(geom)
   node(i,:)=[geom(i,1) geom(i,2) geom(i,3) 1 1 1 1 1.0];    
end
%
end
%----------------------------------------------------------------------------------
%% RACK 
if Rv==1
%
%Cantos semi-angulares 
%
%         geom=      [1 r2+r1+b1+r2*cos(pi/2-q1)+d1*cos(q1)+bs*sin(q1)             d1+r2+r2*cos(pi/2-q1)+bs*cos(q1)     
%                     2 r2+r1+b1+r2*cos(pi/2-q1)+d1*cos(q1)                        d1+r2+r2*cos(pi/2-q1) %%%   
%                     3 r1+b1+r2*cos(pi/2-q1)+d1*cos(q1)                           r2-r2*sin(pi/2-q1)+d1*sin(q1)
%                     4 r1+b1+r2*cos(pi/2-q1)                                      r2-r2*sin(pi/2-q1)            %%% 
%                     5 r1+b1                                                      0
%                     6 r1                                                         0
%                     7 0                                                          r1
%                     8 0                                                          r1+h
%                     9 cz*r3                                                      r1+h+r3
%                     10 cz*(r3+b2)                                                r1+h+r3
%                     11 cz*(r3+b2+r4*cos(pi/2-q2))                                r1+h+r3-r4+r4*sin(pi/2-q2)
%                     12 cz*(r3+b2+r4*cos(pi/2-q2)+d2*cos(q2))                     r1+h+r3-r4+r4*sin(pi/2-q2)-d2*sin(q2)
%                     13 cz*(r3+r3+b2+r3*cos(pi/2-q2)+d2*cos(q2))                  r1+h+r3-(d2+r3+r4*cos(pi/2-q1))%%%%%
%                     14 cz*(r3+r3+b2+r3*cos(pi/2-q2)+d2*cos(q2)+bs*sin(q2))       r1+h+r3-(d2+r3+r4*cos(pi/2-q1))-bs*cos(q2)];   
%
%Cantos totalmennte retos   
%
        geom=[ 1    b1+d1*cos(q1)+bs*sin(q1)            d1*sin(q1)-bs*cos(q1)
               2    b1+d1*cos(q1)+(bs/2)*sin(q1)        d1*sin(q1)-(bs/2)*cos(q1)           
               3    b1+d1*cos(q1)                       d1*sin(q1)
               4    b1+(d1/2)*cos(q1)                  (d1/2)*sin(q1)
               5    b1                                  0
               6    b1*(3/4)                            0
               7    b1*(1/2)                            0
               8    b1*(1/4)                            0
               9    0                                   0
               10   0                                   h*(1/4)
               11   0                                   h*(1/2)
               12   0                                   h*(3/4)
               13   0                                   h
               14   b2*(1/4)                            h
               15   b2*(1/2)                            h
               16   b2*(3/4)                            h
               17   b2                                  h
               18   b2+(d2/2)*cos(q2)                   h-(d2/2)*sin(q2)
               19   b2+d2*cos(q2)                       h-d2*sin(q2)   
               20   b2+d2*cos(q2)+bs*sin(q2)            h-d2*sin(q2)+bs*cos(q2)
               21   b2+d2*cos(q2)+(bs/2)*sin(q2)        h-d2*sin(q2)+(bs/2)*cos(q2)];
%             
for i=1:length(geom)
   node(i,:)=[geom(i,1) geom(i,2) geom(i,3) 1 1 1 1 1.0];    
end
end
%----------------------------------------------------------------------------------
%% ELEMENTOS
for i=1:size(node,1)-1
   elem(i,:)=[i i i+1 t 100];     
end

%% DEFAULT
springs=[0];%    
constraints=[0];%
%Revisão
node(:,1:3);
%

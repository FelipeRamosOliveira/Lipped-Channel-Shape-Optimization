%% OTMIZAÇÃO DE PERFIS Ue ATRVAVÉS DO APSO

%Autor (Otmizador)   : Felipe Oliveira
%Autor(Fixas Finitas): João Lazzari

    clc; clear all; close all;
%%  I.CHAMAR TODAS AS PASTAS NECESSÁRIAS

%   1° PASTAS DAS ROTINAS
    global currentlocation 
    wpath=what;
    currentlocation=wpath.path;
    addpath([currentlocation]);
    addpath([currentlocation,'\OTIMIZADOR']);
    addpath([currentlocation,'\OTIMIZADOR\PSO']);
    addpath([currentlocation,'\OTIMIZADOR\FAIXAS FINITAS']);
    addpath([currentlocation,'\OTIMIZADOR\GENERATIVO']);
    addpath([currentlocation,'\STRENGTH']);

%%  II.OTIMIZAÇÃO
    global Contagem Lf t l_log E fy L 
    %
%   PARÂMETROS DE ANÁLISE DO PSO
    
    Nint=1000;      % INTERAÇÕE
    Npop=20;        % POPULAÇÃO DO ENXAME  
    Nrod=1;         % NÚMERO DE RODADAS
    Gamma=0.95;     % FATOR DE ACELERAÇÃO 
    
%   CARCTERISTICAS IMPOSTAS AO PROBLEMA      

    L= [750];               %Comprimentos de vão/coluna (mm)
    Lf=[100:25:600];        %Laguras das bobinas (mm) 
    t= [1.5:0.125:4];       %Epessuras (mm)|Referência comercial 
    E= [210];               %Modulo de Young (kN/mm2)
    fy=[0.345];             %Resistência ao escoamento (kN/mm2)
   
%   MATRIZ DE COMBINAÇÃO 
    C=combvec(Lf,t,L,E,fy)';
    
%   ABRIR CSV (III)
    Titulo=['Ue_L750_fy345_',date,'.csv'];  
    fid = fopen(Titulo,'wt');
%   Cabeceira
    fprintf(fid,'E;fy;L;Lf;t;Pn;bw;bf;bs;Theta;LambdaG;LambdaL;LambdaD;Norma;Gustavo');            
    
%   LOOP NAS COMBINAÇÃOES 
     for K=1:length(C(:,1))
     display(length(C),'Total de perfis')   
     display(K,'Perfil atual')
     
     Lf=C(K,1);                     %Laguras das bobinas (mm)
     t=C(K,2);                      %Epessuras (mm)
     L=C(K,3);                      %Comprimentos de vão/coluna (mm)
     l_log=log10(C(K,3));           %Log do vão 
     E=C(K,4);                      %Modulo de Young (kN/mm)
     fy=C(K,5);                     %Resistência ao escoamento (N/mm)


%   LIMITES (Condicionados as diferentes bobinas)    
%              bf          D          Theta
    Lb=[       5           5           15];    %INFERIORES (Pi/2 á pi/6)
    Ub=[0.75.*(Lf./2)  0.25*(Lf./2)    90];    %SUPERIORES
    
%   CÓDIGO PRINCIPAL
    tic
    [Pcr,Dim,Lb,Ub]=PSO4(Lb,Ub,Nint,Npop,Gamma,Nrod);
    
%   TEMPO POR INTERAÇÃO
    TempoT=toc;
    TempoR=toc/Contagem;
    display(Contagem,'Acessos a Fob')
    display(TempoR  ,'Tempo por Iterção')
        
    
%   MATRIZ DE RESULTADOS
    M_Result(K,:)=[Pcr Dim];
    
%   RECUPERAR OS LAMBDAS
     x=[Dim];                                       %Transforma parâmetros em vetor
     [coord,mat,elem,Comp]=parametrico(x);          %Ajustar a posião ótima dos nós
     [~,plot_ass]=faixas(coord,elem,mat,Comp);      %MFF|Saida em tensão
     [Ref,LambdaG]=MRDN (plot_ass,coord,elem);
     [LD,LambdaL,LambdaD]=INT_L_D (x,plot_ass,coord,elem);
     
     Esbeltezes(K,:)=[LambdaG LambdaL LambdaD];
     Resistencias(K,:)=[Ref LD];
     
%%  III.ARQUIVO DE SAÍDA     

%   PARMETRIZAR A SOLUÇÃO
    Rd(K)=M_Result(K,1);
    %
    bf(K)=M_Result(K,2);
    bs(K)= M_Result(K,3);
    Lf=C(K,1);
    bw(K)=Lf-2.*bs(K)-2.*bf(K);
    q(K)=M_Result(K,4);
    %
    LG(K)=Esbeltezes(K,1);
    LL(K)=Esbeltezes(K,2);
    LD(K)=Esbeltezes(K,3);
    %
    NeN(K)=    Resistencias(K,1);
    NeLD(K)=   Resistencias(K,2);   
    %Dados
    fprintf(fid,'\n  %.2f;%.3f;%.2f; %.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f;%.2f',...
    C(K,4),C(K,5),C(K,3),C(K,1),C(K,2),Rd(K),bw(K),bf(K),bs(K),q(K),LG(K),LL(K),LD(K),NeN(K),NeLD(K));  
    end
%   FECHAR CSV DEPOIS DO FIM DO LOOP
    fclose(fid);
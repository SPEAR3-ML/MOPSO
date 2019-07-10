%test the MOPSO algorithm
%created by X. Huang, 1/8/2014

clear

global vrange

Nobj = 2;
Nvar = 6;
Npop = 100;
Ngen = 50;

vrange = [-ones(Nvar,1), ones(Nvar,1)]*150; 

% %initial solution, in this test it is random
% p0 = randn(1,Nvar)*5; 
% 
% %in reality, we may want to read the present setpoints as below
% %p0 = getSetPt;  %write your function getSetPt
% 
% x0 = (p0'-vrange(:,1))./(vrange(:,2)-vrange(:,1));

global g_cnt g_data
g_data=[];
g_cnt = 0;



%% 

gbest=mopsomain(Npop,Ngen,Nobj,Nvar);
% diary off

save tmpMOPSOdata


%% 

pl_solution






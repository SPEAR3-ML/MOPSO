function gbest = mopsomain(Npop,Ngen,Nobj,Nvar,varargin)
%main function for multi-objective particle swarm optimization (MOPSO)
%created by X. Huang, 1/7/2014
%

if nargin<7
    %intialize and evaluate
    [f0,v0,pbest,gbest] = mopso_initialize(Npop,Ngen,Nobj,Nvar);
else
    da = varargin{1};
    f0 = da.f0;
    v0 = da.v0;
    pbest = da.pbest;
    gbest = da.gbest;
end
global gset_mopso g_mum
if isempty(gset_mopso)
    gset_mopso.w = 0.4;
    gset_mopso.c1 = 1.0;
    gset_mopso.c2 = 1.0;
end
if isempty(g_mum)
    g_mum = 60;
end
w = gset_mopso.w;
c1 = gset_mopso.c1;
c2 = gset_mopso.c2;
r1 = 0.5;
r2 = 0.5;

iter = 0;
while iter < Ngen
    iter = iter + 1;
     r1 = rand; %0.5+0.15*randn;
     r2 = rand; %0.5+0.15*randn;
    
    f0(:,Nvar+1:end) = [];
    for ii=1:Npop
        rnd = max(1,round(Npop*0.3*rand));
        v0(ii,:) = w*v0(ii,:)+c1*r1*(pbest(ii,1:Nvar) - f0(ii,1:Nvar))+c2*r2*(gbest(rnd,1:Nvar) - f0(ii,1:Nvar));
        f0(ii,1:Nvar) = f0(ii,1:Nvar) + v0(ii,:);
        
        if rand < 1.0/Nvar
            %mutation
            f0(ii,1:Nvar) = mutate(f0(ii,1:Nvar),g_mum);
        end
        
        %bring all position within range
        for iv=1:Nvar
           if f0(ii,iv)<0
               f0(ii,iv) = 0;
           end
           if f0(ii,iv)>1
               f0(ii,iv) = 1;
           end
        end
    end
    
    f0=mass_evaluate(f0, Nobj, Nvar);
    
    %update pbest
    for ii=1:Npop
        res = isdominated(f0(ii,Nvar+1:Nvar+Nobj), pbest(ii,Nvar+1:Nvar+Nobj));
        if (res==1) | ((res==0) & (rand>0.5))
            pbest(ii,:) = f0(ii,:);
         end
    end
    
    %update gbest
    gbest_tmp = non_domination_sort_mod([f0(:,1:Nobj+Nvar); gbest(:,1:Nobj+Nvar)], Nobj, Nvar);
    
%     gbest = gbest_tmp(1:Npop,:);
    gbest = replace_chromosome(gbest_tmp, Nobj, Nvar, Npop);

    save(['generation_' num2str(iter) '.mat']);
end


end %function

    function [f0,v0,pbest,gbest] = mopso_initialize(Npop,Ngen,Nobj,Nvar)
        f0 = rand(Npop,Nvar+Nobj);
        f0(:,Nvar+1:end) = NaN;
        
        v0 = rand(Npop,Nvar)*0.1;
        f0=mass_evaluate(f0, Nobj, Nvar);
        pbest = f0;
        gbest = non_domination_sort_mod([f0(:,1:Nobj+Nvar)], Nobj, Nvar);
    end
    function res = isdominated(f1,f2)
        %compare if f1 and f2 dominate one another
        %res=1, f1 dominate f2  (i.e., all f1 elements are smaller or equal than
        %countparts in f2)
        %res=-1, f2 dominate f1
        %res=0, non-dominated
        d = f1-f2;
        if max(d)<=0
            res = 1;
        elseif min(d)>=0
            res = -1;
        else
            res = 0;
        end
        
    end

    function xn = mutate(x0,mum)
        %perform mutation on chromosome x0
        
        xn = x0;
        
        for j = 1 : length(x0)
            r(j) = rand(1);
            if r(j) < 0.5
                delta(j) = (2*r(j))^(1/(mum+1)) - 1;
            else
                delta(j) = 1 - (2*(1 - r(j)))^(1/(mum+1));
            end
            % Generate the corresponding child element.
            xn(j) = x0(j) + delta(j);
            % Make sure that the generated element is within the decision
            % space.
            if xn(j) > 1
                xn(j) = 1;
            elseif xn(j) < 0
                xn(j) = 0;
            end
        end
        
    end

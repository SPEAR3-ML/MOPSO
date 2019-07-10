function obj = func_obj(x)
%in this function we define the objective function
%you need not to change the first block, which does the parameter boundary
%control and scaling. 
%

global vrange
Nvar = size(vrange, 1);

if size(x,1)==1
    x = x';
end
p = vrange(:,1) + (vrange(:,2) - vrange(:,1)).*x;

if min(x)<0 || max(x)>1
    dxlim = 0;
    for ii=1:Nvar
        if x(ii)<0
            dxlim = dxlim + abs(x(ii));
        elseif x(ii)>1
            dxlim = dxlim + abs(x(ii)-1);
        end
    end
    
    obj = NaN; %-5 + dxlim^2;
    return;
end

%% evaluate the objective function

asum = 0;
for i = 1 : Nvar - 1
    asum = asum - 10*exp(-0.2*sqrt((p(i))^2 + (p(i + 1))^2));
end
%add a random number to simulate noise. 
% asum = asum + randn*0.001;
obj(1) = asum;


asum = 0;
for i = 1 : Nvar
    asum = asum + (abs(p(i))^0.8 + 5*(sin(p(i)))^3);
end
obj(2) = asum;

obj = obj(:);
%% save data to a global variable. 
global g_data g_cnt
g_cnt = g_cnt+1;
g_data(g_cnt,:) = [p',obj(:)']; %

%uncomment the next line to print out the solution
%     [g_cnt, p',obj]


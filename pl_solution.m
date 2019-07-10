genl = [1,10:10:50];
for ig=1:length(genl)
   load(['generation_' num2str(genl(ig)) '.mat']);
   d.f0 = f0;
   d.pbest = pbest;
   d.gbest = gbest;
   d.v0 = v0;
   d.gen = genl(ig);
   fprintf('norm(v0) %f, at gen %d\n',norm(v0), d.gen);
   dall(ig) = d;
   cstr{ig} = ['gen ', num2str(d.gen)];
end


%% plot
cl = colormap;

figure(101)
for ii=1:length(genl)
h(ii) = plot(dall(ii).gbest(:,Nvar+1),dall(ii).gbest(:,Nvar+2),'s');
set(h(ii),'color',cl(ii*8,:));

hold on
end
hold off
xlabel('obj 1')
ylabel('obj 2')
title('gbest')
legend(h, cstr);
title('MOPSO, gbest, POP=100')
 
figure(102)
for ii=1:length(genl)
h(ii) = plot(dall(ii).f0(:,Nvar+1),dall(ii).f0(:,Nvar+2),'s');
set(h(ii),'color',cl(ii*8,:));

hold on
end
hold off
xlabel('obj 1')
ylabel('obj 2')
title('f0')

figure(103)
for ii=1:length(genl)
h(ii) = plot(dall(ii).pbest(:,Nvar+1),dall(ii).pbest(:,Nvar+2),'s');
set(h(ii),'color',cl(ii*8,:));

hold on
end
hold off
xlabel('obj 1')
ylabel('obj 2')
title('pbest')


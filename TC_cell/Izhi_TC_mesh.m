%find tradjectories and nullclines
clear;clf;
global C k vr vt a b vpeak b_rec d;
C=200; k=1.6;
vr = -65; vt = -60;
a = 0.01; b = 0;
d = 10;
vpeak = 35;
T = 1000; %ms
tau = 1; %ms
n = (T/tau);%timesteps
b_rec = 15;


I_amp = -0.50;
v = vr*ones(1,n); 
u = zeros(1,n); % initial values
I = I_amp.*C.*ones(1,n);

 % pulse of input DC current

for i=1:n-1
    % forward Euler method
    
    if(i>125)
        I(i)=0;
    end
    
    v(i+1)=v(i)+tau*(k*(v(i)-vr)*(v(i)-vt)-u(i)+I(i))/C;

    u(i+1)=u(i)+tau*a*(b*(v(i)+60)-u(i));
    if v(i+1)>=vpeak+0.1*u(i+1) % a spike is fired!
        v(i)=vpeak; % padding the spike amplitude
        v(i+1)=vr-0.1*u(i+1); % membrane voltage reset
        u(i+1)=u(i+1)+d; % recovery variable update
    end
    
    if(v(i)<-65)
        b = b_rec;       
    else
        b = 0;
    end
end

        
    
% Find nullclines    
min_val = -200;
max_val = 100;
tic = 2;
n = length(min_val:tic:max_val);
[V, U] = meshgrid(min_val:tic:max_val, min_val:tic:max_val);
dV = zeros(n);
dU = zeros(n);
i = 0;j=0;
for i = 1:n
    for j = 1:n
        dV(i,j) = dvdt(V(i,j), U(i,j), I(1));
        dU(i,j) = dudt(V(i,j), U(i,j));
    end
end

figure(1);
%quiver(V, U, dV, dU);hold on;
subplot(2,1,1);
plot(v(100:200),u(100:200),'k');hold on;
contour(V, U, dV,'LevelList',0,'LineColor','b');hold on;
contour(V, U, dU,'LevelList',0,'LineColor','r');hold on;

axis([-90,vpeak,-200,100]);
xlabel('voltage');
ylabel('recovery variable u');

subplot(2,1,2);
plot(tau.*(1:T),v);
xlabel('ms');
ylabel('v');
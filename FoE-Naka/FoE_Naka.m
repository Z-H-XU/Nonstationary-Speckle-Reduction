
function despeckled=FoE_Naka(SARimg,L)

%% L can only be {1, 2, 3, 4, 5, 8}

fsz = 7;
filename = '7x7_15.mat';
load (filename);
filt = cell(48+1,1);
for i=1:48
    filt{i} = reshape(filters(:,i), fsz, fsz);
end
filt{end} = size(SARimg);
%% Load default parameter settings
para = setparameters(L,SARimg);
%% model parameters
theta = theta*0.2;
lambda = para.lambda;
mu = para.mu;
%% algorithm parameters
alpha = para.alpha;
beta  = para.beta;
maxiter = para.maxiter;
x0 = para.x0;
[M,N] = size(SARimg);
w0 = log(x0);
%% despeckling process
despeckled = ipiano_Despeck_AmplitudeCombEXP2(SARimg, w0, filt, theta, maxiter, alpha, beta, mu, lambda);

return

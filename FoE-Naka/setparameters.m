function para = setparameters(L,f)
if L == 1
    para.alpha = 1e-5;
    para.beta  = 0.75;
    para.lambda = 160;
    para.mu = 0.004;
    para.maxiter = 600;
    para.x0 = ones(size(f(:)))*255/2;
end
if L == 2
    para.alpha = 1e-5;
    para.beta  = 0.75;
    para.lambda = 250;
    para.mu = 0.006;
    para.maxiter = 400;
    para.x0 = ones(size(f(:)))*255/2;
end
if L == 3
    para.alpha = 1e-5;
    para.beta  = 0.75;
    para.lambda = 310;
    para.mu = 0.008;
    para.maxiter = 300;
    para.x0 = ones(size(f(:)))*255/2;
end
if L == 4
    para.alpha = 1e-5;
    para.beta  = 0.75;
    para.lambda = 390;
    para.mu = 0.01;
    para.maxiter = 200;
    para.x0 = ones(size(f(:)))*255/2;
end
if L == 5
    para.alpha = 1e-4;
    para.beta  = 0.75;
    para.lambda = 450;
    para.mu = 0.01;
    para.maxiter = 150;
%     para.x0 = f(:);
    para.x0 = ones(size(f(:)))*255/2;
end
if L == 8
    para.alpha = 1e-4;
    para.beta  = 0.75;
    para.lambda = 550;
    para.mu = 0.02;
    para.maxiter = 120;
%     para.x0 = f(:);
    para.x0 = ones(size(f(:)))*255/2;
end



function [var, g] = LogMM_FOE_SAR_ConvoMEX(x,K,f,lambda,theta,zm,omega_current,mus,sigma2)

    [var1, g] = Var_Gradient_Data(x,f,lambda,zm,omega_current,mus,sigma2);

    q = length(K)-1;
    r = K{end}(1);
    c = K{end}(2);

    var=0;
    parfor i=1:q
        Kx = mex_convolution(x,K{i},r,c);
        var = var + sum(rou(Kx)) * theta(i);
        Ne1 = 2*Kx./ (1 + Kx.^2);
        g = g + mex_convolution_transpose(Ne1,K{i},r,c) * theta(i);
    end
    var = var + var1;

return

function y = rou(x)
y = log(1 + x.^2);

function w = backward_EXP(w0, f, lambda, mu, alpha)
iter = 10;
k = 2*alpha*mu;
q = 2*alpha*lambda;
w = w0;
for i = 1:iter
%     t = f.^2./x.^2;
    grad = w - w0 + q*(1-f.^2.*exp(-2*w)) + k*(exp(2*w)-f.^2);
    h = 1 + 2*q*f.^2.*exp(-2*w) + 2*k*exp(2*w);
    
    dw = grad./h;
    p = 1;
    w = w -p*dw;
    if norm(grad) < 1e-6
        break;
    end
end
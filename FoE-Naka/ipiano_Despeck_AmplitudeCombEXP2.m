function x = ipiano_Despeck_AmplitudeCombEXP2(f, w, filt, theta, maxiter, alpha, beta, mu, lambda)
m = length(filt) - 1;
[M,N] = size(f);

tic;
w_old = w;

for iter = 1:maxiter
  %% compute gradient
  grad = 0;
  x = exp(w);
  parfor i=1:m
    tmp = mex_convolution(x,filt{i},M,N);
%     fn = fn + sum(theta(i)*log(1+abs(tmp).^2));
    grad = grad + 2*theta(i)*mex_convolution_transpose(tmp./(1 + tmp.^2),filt{i},M,N);
  end
  grad = grad.*x;
%   grad2 = 2*lambda*(1 - f(:).^2./x.^2) + 2*mu*(x.^2 - f(:).^2);
%   res = grad2 + grad;
%   res = sqrt(sum(res.^2)/length(res));
  
%   energy = fn + lambda*sum(2*log(x)+f(:).^2./x.^2) + mu*sum(x.^2 - 2*f(:).^2.*log(x));  
  if iter > 1
    a = norm(grad-old_grad);
    b = norm(w-w_old);
    if a > b/alpha
      alpha = 0.99*b/a;
    end
  end  
  %% remember old values
  w_ = w_old;
  w_old = w;
  old_grad = grad;
  
  %% 1. make forward step
  w = w - alpha*grad + beta*(w-w_);
  
  %% 2. make backward step
%   k = 2*alpha*mu;
%   x = (x + sqrt(x.^2 + 4*(1+k)*k*f(:).^2))/(2*(1+k));
  w = backward_EXP(w, f(:), lambda, mu, alpha);
%   x = max(1e-3,min(x,255));
  w = min(w,log(255));
 
  alpha = alpha*1.05;
end
x = exp(w);
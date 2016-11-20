


function [lambda,options] = SimulatedSAR_OptsSetting(L,sigma)


mK=length(sigma);
lambda(mK)=0;
for k=1:mK
      if sigma(k) >= 50
          lambda(k) = 50/sigma(k) * 0.8;
      elseif sigma(k) >= 25
          lambda(k) = 25/sigma(k)*0.9; 
      elseif sigma(k) >= 15
          lambda(k) = 15/sigma(k)*1.0; 
      else
          lambda(k) = sigma(k) * 1.2;
      end
end

lambda = 1e-5*lambda*1.2.^(L-1);
options.maxIter=max(floor(20-(L-1)*1.5),5); 
options.display = 'none';
options.maxFunEvals = 100;
options.Method = 'lbfgs'; 

return;
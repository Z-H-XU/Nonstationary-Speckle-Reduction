
% To simplify the noise sampling, we use the LogNMM with a single mixture,
% which is equivalent to the log-normal distribution, to simulate the synthetic SAR data. 
% It is worth noting that the log-normal distribution can be applied to model SAR in both intensity and amplitude format.
% Here, we use log-normal distribution to model SAR data in the amplitude format, 
% due to that this distribution is best suited for amplitude data and heterogeneous surfaces 

function [img, data] = LogNorGen_MultiLookingProc(img,L)

    if L>2
        img=blow(img);
    end

    data=0*img;
    [r,c]=size(img);
    for i=1:r
        for j=1:c
            m = (img(i,j));
            v=840;
            mu = log((m^2)/sqrt(v+m^2));
            sigma = sqrt(log(v/(m^2)+1));
            data(i,j)= lognrnd(1*mu,sigma);
        end
    end

     switch L
          case 1
            data=MultiLooksProc(data,1);
            img=MultiLooksProc(img,1);
         case 2
             data=MultiLooksProc(data,2);
            img=MultiLooksProc(img,2);
         case 3
              data=MultiLooksProc(data,3);
              img=MultiLooksProc(img,3);
         case 4
            data=MultiLooksProc(data,2);
            data=MultiLooksProc(data',2);
            data=data';
            img=MultiLooksProc(img,2);
            img=MultiLooksProc(img',2);
            img=img';
         case 8
            data=MultiLooksProc(data,2);
            data=MultiLooksProc(data',4);
            data=data';
            img=MultiLooksProc(img,2);
            img=MultiLooksProc(img',4);
            img=img';
          case 16
            data=MultiLooksProc(data,4);
            data=MultiLooksProc(data',4);
            data=data';
            img=MultiLooksProc(img,4);
            img=MultiLooksProc(img',4);
            img=img';
     end


return;


function mlooksdata = MultiLooksProc(data,looks)

    [rax,azy]=size(data);
    ml_azy=azy/looks;
    mlooksdata=zeros(rax,ml_azy);

    for kk=1:ml_azy
        idk=looks*(kk-1)+1:kk*looks;
        mlooksdata(:,kk)=sum(data(:,idk),2)/looks;
    end

return
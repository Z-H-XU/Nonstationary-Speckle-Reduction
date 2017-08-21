function data = Mask_MultiLookingProc(img,L)

    if L>2
        img=blow(img);
    end

    data=img;

    
     switch L
          case 1
            data=MultiLooksProc(data,1);
         case 2
             data=MultiLooksProc(data,2);
         case 3
              data=MultiLooksProc(data,3);
         case 4
            data=MultiLooksProc(data,2);
            data=MultiLooksProc(data',2);
            data=data';
         case 8
            data=MultiLooksProc(data,2);
            data=MultiLooksProc(data',4);
            data=data';
          case 16
            data=MultiLooksProc(data,4);
            data=MultiLooksProc(data',4);
            data=data';
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
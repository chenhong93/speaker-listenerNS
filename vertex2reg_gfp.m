function gfp_region=vertex2reg_gfp(wall,logfinal,showind,baseind)
nn=length(showind);
ntime=size(wall,3);
gfp_region=zeros(size(wall,1),nn,nn,ntime);
for i=1:nn
    tempi=showind{i};
    for j=1:nn
        tempj=showind{j};
        tempwall=[];
        templog=logfinal(tempi,tempj);
        for x=1:length(tempi)
            for y=1:length(tempj)
                if templog(x,y)==0
                    tempw=squeeze(wall(:,tempi(x),:,tempj(y)));
                    if ~isempty(baseind)
                        for s=1:size(tempw,1)
                            tempw(s,:)=tempw(s,:)-mean(tempw(s,baseind));
                        end
                    end
                    tempwall=cat(3,tempwall,tempw);
                end
            end
        end
        if ~isempty(tempwall)
            gfp_region(:,i,j,:)=std(tempwall,1,3);
        end
    end
end
end
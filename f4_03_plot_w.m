
%%
% seperate index for brain regions
subnum=22;
ntime=801;
nchan=196;
nsin=196;

hemi={'L','R'};
tag={'BA44','BA45','vBA6','M1','S1','aSMG','TPJ','IPL','HG','STG','STS','MTGITG','ATL'};
load(['res' filesep 'tempmat' filesep 'allind.mat']);% region index for 196 source  
nametag={};
showind={};
allind=[];
ii=1;
for i=1:length(tag)
    for h=1:2
        eval(['tempind= ' hemi{h} tag{i} ';']);
        templen=length(allind);
        allind=[allind tempind];
        nametag{ii}=[hemi{h} tag{i}];
        showind{ii}=(templen+1):(templen+length(tempind));
        ii=ii+1;
    end
end
tempind={[1 3],[2 4],[5 7 9],[6 8 10],[23 25],[24 26],[11 13 15],[12 14 16],[17 19],[18 20]};
namereg={'IFG-L','IFG-R','Pre/PostCG-L','Pre/PostCG-R','MTG/ITG-L','MTG/ITG-R',...
    'SMG/IPL-L','SMG/IPL-R','STG/HG-L','STG/HG-R'};
indreg={};
for i=1:length(tempind)
    temp=tempind{i};
    tempreg=[];
    for j=1:length(temp)
        tempreg=[tempreg showind{temp(j)}];
    end
    indreg{i}=tempreg;
end

%%%%%%%%%%%%%%%load TRF weights%%%%%%%%%%%%%%%%%%%%%%%%%%
% % load TRF weights
% % load mask
% load('logrr.mat');
% nreg=length(tempind);
% aa=mean(logrr,1);
% indnolis=find(aa==1);
% aa=mean(logrr,2);
% indnospe=find(aa==1);
% templog=double(logrr);
% temp=zeros(1,size(templog,2));
% temp(indnolis)=1;
% for i=1:size(logrr,1)
%     if ~ismember(i,indnospe)
%         templog(i,:)=temp;
%     end
% end
% templog=templog==1;
% logrr=templog;
% w=zeros(subnum,nsin,ntime,nchan);
% for i=1:subnum
%     temps = ['sub-' num2str(floor((i+6)/10)) num2str(mod(i+6,10))];
%     load(['res' filesep 'speaker-listenerNS' filesep temps filesep temps '_SLNS.mat'],...
%         'modelall');
%     disp(num2str(i));
%     for s=1:8
%         for n=1:nsin
%             w(i,n,:,:)=squeeze(w(i,n,:,:))+squeeze(modelall{i,s,n}.w);
%         end
%     end
% end
% wall=w/8;% average across 8 stories
% wall=wall(:,allind,:,allind);
% tempt=modelall{subnum,1,1}.t;
% wreg_ori=vertex2reg_gfp(wall,logrr,indreg,[]);
% save('weight_SL_ori.mat','wreg_ori','tempt','-v7.3');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load directly to save time
load(['res' filesep 'speaker-listenerNS' filesep 'weight_SL_ori.mat'],'wreg_ori','tempt');
ind1=21;ind2=781;% discard first and last 20 timepoints for plot
x=tempt(ind1:ind2);
xx=fliplr(-x); % timelag 

%% single region pair->listener lead
figure;hold on;
indss1=4;% speaker Pre/PostCG-R
indss2=10;% listener STG/HG-R
aa=squeeze(wreg_ori(:,indss1,indss2,ind1:ind2));% TRF weights of this pair
aa=fliplr(aa);% timelag: negative-speaker lead; positive-listener lead
% plot single speaker-listener pair
for i=1:subnum
    temp=smooth(aa(i,:),20);
    plot(xx,temp,'Color',[.5 .5 .5]);
end
% plot average
plot(xx,smooth(mean(aa),20),'color','r','LineWidth',1.5);
xlabel('Timelag(ms)');
ylabel('Power of TRF w');
set(gca,'fontsize',15);
xlim([-4000 4000]);
set(gca,'ytick',0.05:0.05:0.25);
ylim([0.02 0.22]);


%% single region pair->speaker lead
figure;hold on;
indss1=1;% speaker IFG-L
indss2=10;% listener STG/HG-R
aa=squeeze(wreg_ori(:,indss1,indss2,ind1:ind2));% TRF weights of this pair
aa=fliplr(aa);% timelag: negative-speaker lead; positive-listener lead
% plot single speaker-listener pair
for i=1:subnum
    temp=smooth(aa(i,:),20);
    plot(xx,temp,'Color',[.5 .5 .5]);
end
% plot average
plot(xx,smooth(mean(aa),20),'color','r','LineWidth',1.5);
xlabel('Timelag(ms)');
ylabel('Power of TRF w');
set(gca,'fontsize',15);
xlim([-4000 4000]);
ylim([0.02 0.2]);
set(gca,'ytick',0.05:0.05:0.2);



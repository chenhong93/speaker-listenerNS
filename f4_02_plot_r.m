subnum=22;
subs=8;
allcorr_singles=cell(subnum,subs);
for i=1:subnum
    temps = ['sub-' num2str(floor((i+6)/10)) num2str(mod(i+6,10))];
    a=load(['res' filesep 'speaker-listenerNS' filesep temps filesep temps '_SLNS.mat'],...
        'allcorr_singles');
    allcorr_singles(i,:)=a.allcorr_singles(i,:);
end

nperm=5;
nchan=196;

% seperate index for brain regions
ntime_show=1;
hemi={'L','R'};
tag={'BA44','BA45','vBA6','M1','S1','aSMG','TPJ','IPL','MTGITG','ATL','HG','STG','STS'};
load('allind.mat');% region index for 196 source 
nametag={};
showind={};
allind=[];
ii=1;
for h=1:2
    for i=1:length(tag)
        eval(['tempind= ' hemi{h} tag{i} ';']);
        templen=length(allind);
        allind=[allind tempind];
        nametag{ii}=[hemi{h} tag{i}];
        showind{ii}=(templen+1):(templen+length(tempind));
        ii=ii+1;
    end
end
% combine r values for each speaker-listener pair
tempcor_ori=zeros(subnum,subs,196,196);
for i=1:subnum
    for s=1:subs
        tempcor_ori(i,s,:,:)=allcorr_singles{i,s};
    end
end
mean_ori=squeeze(mean(tempcor_ori,[1 2]));
mshow=mean_ori';
% plot r values for all parcel pairs
load('mask_direct_trf.mat','logrr2');% mask for significance
f=figure;hold on;
imagesc(mshow(allind,allind));colormap hot;logrr=logrr2';
for i=1:size(logrr,1)
    for j=1:size(logrr,2)
        if logrr(i,j)
            fill([i-0.5 i-0.5 i+0.5 i+0.5],[j-0.5 j+0.5 j+0.5 j-0.5],[1 1 1],...
                'facealpha',0.5,'edgecolor','none');
        end
    end
end
% seperate 10 brain regions
tempind={1:2,3:5,6:8,9:10,11:13,14:15,16:18,19:21,22:23,24:26};
namereg={'IFG-L','Pre/PostCG-L','SMG/IPL-L','MTG/ITG-L','STG/HG-L',...
    'IFG-R','Pre/PostCG-R','SMG/IPL-R','MTG/ITG-R','STG/HG-R'};
indreg={};
for i=1:length(tempind)
    temp=tempind{i};
    tempreg=[];
    for j=1:length(temp)
        tempreg=[tempreg showind{temp(j)}];
    end
    indreg{i}=tempreg;
end
% plot seperate lines for 10 brain regions
addregionline(namereg,indreg,nchan);
set(gca, 'YDir', 'reverse');

% plot marginal dustribution for speaker and listener
signum=~logrr;
pos=[744,630,625.800000000000,70.2000000000001];
figure;plot(1:196,sum(signum,1),'k','linewidth',2);
ylim([0 196]);
xlim([1 196]);
axis off;
set(gcf,'position',pos);
figure;plot(1:196,sum(signum,2),'k','linewidth',2);
ylim([0 196]);
xlim([1 196]);
axis off;
set(gcf,'position',pos);

% plot single speaker-listener pair results
mm=squeeze(mean(tempcor_ori(:,:,allind,allind),2));
% speaker's IFG-R
pos=[729,265.800000000000,399.200000000000,528.800000000000];
rr=zeros(subnum,length(namereg));
indspe=6;
for i=1:subnum
    for j=1:length(namereg)
        temp=squeeze(mm(i,indreg{j},indreg{indspe}));
        rr(i,j)=mean(temp(:));
    end
end
figure;imagesc(rr);
caxis([0 0.04]);
colormap hot;
set(gca,'xtick',1:10);set(gca,'xticklabel',namereg);
set(gca,'xticklabelrotation',45);
colorbar;
set(gca,'fontsize',15);
set(gca,'ytick',5:5:20);
ylabel('Subject');
xlabel('Listener region');
set(gcf,'position',pos);
set(gca,'ytick',1:5:22);
set(gca,'YTickLabel',{'sub-07','sub-12','sub-17','sub-22','sub-27'});

% listener's STG/HG-R
rr=zeros(subnum,length(namereg));
indlis=10;
for i=1:subnum
    for j=1:length(namereg)
        temp=squeeze(mm(i,indreg{indlis},indreg{j}));
        rr(i,j)=mean(temp(:));
    end
end
figure;imagesc(rr);
caxis([0 0.04]);
colormap hot;
set(gca,'xtick',1:10);set(gca,'xticklabel',namereg);
set(gca,'xticklabelrotation',45);
hh=colorbar;hh.Ticks=0:0.01:0.04;
set(gca,'fontsize',15);
set(gca,'ytick',5:5:20);
ylabel('Subject');
xlabel('Speaker region');
set(gca,'ytick',1:5:22);
set(gca,'YTickLabel',{'sub-07','sub-12','sub-17','sub-22','sub-27'});
set(gcf,'position',pos);

% plot circle
% extract all region-pair r values
rr=zeros(subnum,length(namereg),length(namereg));
for i=1:subnum
    for j=1:length(namereg)
        for k=1:length(namereg)
            temp=squeeze(mm(i,indreg{k},indreg{j}));
            rr(i,j,k)=mean(temp(:));
        end
    end
end
tempp=squeeze(mean(rr,1));
plot_circle(tempp,namereg,[0.005 0.03]);





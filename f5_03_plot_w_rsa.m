
%%
subnum=22;

%%%%%%%%%%%%%%%%%% load %%%%%%%%%%%%%%%%%%%%%%%%
wregall=zeros(subnum,6,10,10,401);
for i=1:subnum
    temps = ['sub-' num2str(floor((i+6)/10)) num2str(mod(i+6,10))];
load(['res' filesep 'feature-drivenNS' filesep temps filesep temps '_featureNS.mat'],...
        'namereg','wreg','ffall','indreg','tempt','showind','tempind');
wregall(i,:,:,:,:)=wreg;
end
wreg=wregall;clear wregall;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind1=10;ind2=391;% discard first and last 100 ms avoiding noise
ii=[1 6 2 7 4 9 3 8 5 10];
x=tempt(ind1:ind2);
xx=fliplr(-x);
wreg0=wreg(:,:,:,:,ind1:ind2);

wreg0(:,:,ii,ii,:)=wreg0;
namereg(ii)=namereg;

%%%%%%%%%%%%%%%%%%%%%%%%%
% RDM index for upper triangle
indtrue=zeros(6,6);
for i=1:6
    for j=1:6
        if i<j
            indtrue(i,j)=1;
        end
    end
end
indtrue=indtrue==1;
ww=reshape(wreg0,[subnum 6 100 382]);
ww=ww(:,:,:,382:-1:1);

% calculate neural temporal RDM
rdmtime=zeros(22,6,6,382);
for t=6:377
    for s=1:22
        temp=squeeze(mean(ww(s,:,:,t-5:t+5),4));% 100 ms time window
        rdmtime(s,:,:,t)=1-corr(temp','Type','Spearman');
    end
end
% calculate neural spatial RDM
rdmspa=zeros(22,6,6,100);
for n=1:100
    for s=1:22
        temp=squeeze(ww(s,:,n,:));
        rdmspa(s,:,:,n)=1-corr(temp','Type','pearson');
    end
end

% establish model RDM
rdmmod=zeros(6,6,4);
% Four-Feature-Domain Model
rdmmod(:,:,1)=[0 1 1 1 1 1
    1 0 0 1 1 1
    1 0 0 1 1 1
    1 1 1 0 0 1
    1 1 1 0 0 1
    1 1 1 1 1 0];

% Continuous-Discrete Format Model
rdmmod(:,:,2)=[0 1 1 0 0 0
    1 0 0 1 1 1
    1 0 0 1 1 1
    0 1 1 0 0 0
    0 1 1 0 0 0
    0 1 1 0 0 0];

% Acoustic-Linguistic Domain Model
rdmmod(:,:,3)=[0 1 1 0 0 1
    1 0 0 1 1 0
    1 0 0 1 1 0
    0 1 1 0 0 1
    0 1 1 0 0 1
    1 0 0 1 1 0];

% Segmental-Tonal Linguistic Model
rdmmod(:,:,4)=[0 nan nan nan nan nan
    nan 0 0 nan nan 1
    nan 0 0 nan nan 1
    nan nan nan 0 nan nan
    nan nan nan nan 0 nan
    nan 1 1 nan nan 0];


% perform RSA for temporal neural RDM
rtime=zeros(22,382,4);
for i=1:22
    for m=1:4
        for t=6:377
            temp1=squeeze(rdmmod(:,:,m));
            temp1=temp1(indtrue);
            temp2=squeeze(rdmtime(i,:,:,t));
            temp2=temp2(indtrue);
            nnnan=find(isnan(temp1));
            if length(nnnan)>0
                nnn=find(~isnan(temp1));
                temp1=temp1(nnn);
                temp2=temp2(nnn);
            end
            rtime(i,t,m)=corr(temp1,temp2,'Type','pearson');
        end
    end
end

% perform RSA for spatial neural RDM
rspa=zeros(22,100,4);
for i=1:22
    for m=1:4
        for n=1:100
            temp1=squeeze(rdmmod(:,:,m));
            temp1=temp1(indtrue);
            temp2=squeeze(rdmspa(i,:,:,n));
            temp2=temp2(indtrue);
            nnnan=find(isnan(temp1));
            if length(nnnan)>0
                nnn=find(~isnan(temp1));
                temp1=temp1(nnn);
                temp2=temp2(nnn);
            end
            rspa(i,n,m)=corr(temp1,temp2,'Type','pearson');
        end
    end
end

% statistics for positive r values timelag range
ppsig=zeros(382,4);
for m=1:4
    for t=6:366
    [~,ppsig(t,m)]=ttest(squeeze(rtime(:,t,m)),0,'tail','right');
    end
end

% manually selected
tsig={[43 209;229 264],[212 233],[17 204],[104 123]};

% plot temporal RSA results
for m=1:4
    figure;hold on;
    plot(xx(6:377),squeeze(rtime(:,6:377,m)),'k');
    plot(xx(6:377),squeeze(mean(rtime(:,6:377,m),1)),...
        'Color','r','LineWidth',2);
    tempind=tsig{m};
    if m==4
        yho=-1.1;
    elseif m==2
        yho=-0.6;
    else
        yho=-0.4;
    end
    for i=1:size(tempind,1)
        disp(num2str(xx([tempind(i,:)])));
        plot(xx([tempind(i,:)]),[yho yho],'k','LineWidth',2);
    end
    xlabel('Timelag(ms)');
    ylabel('Correlation(r value)');
    set(gca,'fontsize',15);
    if m==3
        ylim([-0.6 1]);
    end
    if m==4
        ylim([-1.2 1.2]);
    end
end

% plot four model RDMs
namef={'ac','con','vow','ph','pc','tone'};
for i=1:4
    figure;imagesc(squeeze(rdmmod(:,:,i)));
    set(gca,'xtick',1:6);
    set(gca,'ytick',1:6);
    set(gca,'xticklabel',namef);
    set(gca,'yticklabel',namef);
    colormap gray;colorbar;
    set(gca,'fontsize',13);
end

% plot average TRF weights for 6 features
figure;hold on;
mww=squeeze(mean(ww,[1 3]));
sww=squeeze(std(squeeze(mean(ww,3)),0,1))/sqrt(22);
load(['res' filesep 'tempmat' filesep '6feacolor.mat']);
for i=1:6
    temp1=mww(i,:);
    temp2=sww(i,:);
    plot(xx,temp1,'Color',ac(i,:),'LineWidth',1.5);
end
legend(namef,'AutoUpdate','off');
for i=1:6
    temp1=mww(i,:);
    temp2=sww(i,:);
    fill([xx xx(end:-1:1)],[temp1-temp2 temp1(end:-1:1)+temp2(end:-1:1)],...
        ac(i,:),'EdgeColor','none','FaceAlpha',0.6);
end
xlabel('Timelag(ms)');ylabel('Power of TRF w');
set(gca,'fontsize',15);

% plot example neural RDM for peak (-210ms)
aa=squeeze(mean(rdmtime,1));
figure;imagesc(squeeze(aa(:,:,170)));
set(gca,'xtick',1:6);
set(gca,'ytick',1:6);
set(gca,'xticklabel',namef);
set(gca,'yticklabel',namef);
colormap gray;
set(gca,'fontsize',13);colorbar;


% plot spatial rsa results
rr=reshape(rspa,[subnum,length(namereg),length(namereg),4]);
rr=squeeze(mean(rr,1));
cclim=[0.3 0.55;0.02 0.2;0.2 0.55;0.25 0.9];
for i=1:4
    tempp=squeeze(rr(:,:,i));
    plot_circle(tempp,namereg,cclim(i,:));
end
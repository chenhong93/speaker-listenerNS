

%%
subnum=23;% listener:1-22; speaker:23

for fff=1:6
    % load data
    ffall={'acoustic','consonant','vowel','pitch_height','pitch_change','tone'};
    fname=ffall{fff};
    load(['res' filesep 'featureTRF' filesep 'feature_TRF_' fname '_combine.mat']);
    ttt=modelall{1,1}.t;% timelag
    tnum=length(ttt);
    chanlis=306;% all channel number
    nfea=size(modelall{1,1}.w,1);% number of feature dimensions
    wall=zeros(subnum,nfea,chanlis,tnum);% TRF weight
    for i=1:subnum
        % disp(num2str(i));
        tempw=zeros(8,nfea,chanlis,tnum);
        for s=1:8
            m=modelall{i,s};
            tempw(s,:,:,:)=permute(m.w,[1 3 2]);
        end
        wall(i,:,:,:)=mean(tempw,1);
    end
    %% plot weight
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % listener
    % timelag peak for plot
    tlags={[210 500],[210 650],[220 600],[170 450],[170 450],[80 170 380]};
    temptlag=tlags{fff};
    namefig=['lis' num2str(fff) '-'];
    pos=[744,793,560,257];
    mw=squeeze(mean(wall(1:22,:,:,:),[1 2]));

    % plot all mag channels
    figure;plot(ttt,mw(1:3:306,:),'color',[.3 .3 .3]);
    xlabel('Timelag(ms)');
    ylabel('Amplitude(T)');
    set(gca,'fontsize',15);
    set(gcf,'position',pos);
    hold on;
    ax=gca;yy=ax.YLim;
    for i=1:length(temptlag)
        plot(temptlag([i i]),yy,'r--','linewidth',1.5);
    end
    % print(['fig' filesep namefig 'w'],'-dtiff','-r300');
    %%
    pos=[325.800000000000,640.200000000000,314.400000000000,257.600000000000];
    % plot topoplot for each timelag peak
    for i=1:length(temptlag)
        ttind=find(ttt==temptlag(i));
        mr=squeeze(mean(wall(1:22,:,:,ttind),[1 2]));
        load(['res' filesep 'tempmat' filesep 'namelabel.mat'],'namelabel');
        datas=[];
        datas.label=namelabel;
        datas.dimord='chan_time';
        datas.time=0;
        datas.avg=mr;
        cfg=[];
        cfg.layout    = 'neuromag306mag_helmet.mat';  % Choose the layout matching your channel labels
        cfg.xlim      = [0 0];           % Look exactly at your single time point
        cfg.zlim      = 'maxabs';        % Scale color bar based on maximum absolute value
        cfg.colorbar  = 'yes';           % Display a color scale
        cfg.marker    = 'on';            % Draw dots at sensor positions
        cfg.comment = 'no';
        
        figure;
        ft_topoplotER(cfg, datas);
        set(gcf,'position',pos);
        % print(['fig' filesep namefig 'topo' num2str(i)],'-dtiff','-r300');
    end


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % speaker
    % timelag peak for plot
    tlags={[-150 0 300],[-80 80],[-80 30 350],[-150 70],[-210 -30],[-190 0 80 270]};
    temptlag=tlags{fff};
    namefig=['spe' num2str(fff) '-'];
    
    pos=[744,793,560,257];
    mw=squeeze(mean(wall(23,:,:,:),2));
    figure;plot(ttt,mw(1:3:306,:),'color',[.3 .3 .3]);
    xlabel('Timelag(ms)');
    ylabel('Amplitude(T)');
    set(gca,'fontsize',15);
    set(gcf,'position',pos);
    ax=gca;yy=ax.YLim;hold on;
    for i=1:length(temptlag)
        plot(temptlag([i i]),yy,'r--','linewidth',1.5);
    end
    % print(['fig' filesep namefig 'w'],'-dtiff','-r300');
    
    %% 51--0
    pos=[325.800000000000,640.200000000000,314.400000000000,257.600000000000];
    % plot topoplot for each timelag peak
    for i=1:length(temptlag)
        ttind=find(ttt==temptlag(i));
        mr=squeeze(mean(wall(23,:,:,ttind),2));
        load(['res' filesep 'tempmat' filesep 'namelabel.mat'],'namelabel');
        datas=[];
        datas.label=namelabel;
        datas.dimord='chan_time';
        datas.time=0;
        datas.avg=mr;
        cfg=[];
        cfg.layout    = 'neuromag306mag_helmet.mat';  % Choose the layout matching your channel labels
        cfg.xlim      = [0 0];           % Look exactly at your single time point
        cfg.zlim      = 'maxabs';        % Scale color bar based on maximum absolute value
        cfg.colorbar  = 'yes';           % Display a color scale
        cfg.marker    = 'on';            % Draw dots at sensor positions
        cfg.comment = 'no';
        
        figure;
        ft_topoplotER(cfg, datas);
        set(gcf,'position',pos);
        % print(['fig' filesep namefig 'topo' num2str(i)],'-dtiff','-r300');
    end
    %% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % plot single subject
    figure;hold on;
    pos=[1.058000000000000e+02	375	2.892000000000000e+02	493];
    cmap2=slanCM(37);
    cmap1=slanCM(76);
    % power of TRF weights
    sw=squeeze(std(mean(wall([23 1:22],:,1:3:306,:),2),0,3));
    numnan=2;% discard first and last 20ms for plot
    sw(:,1:numnan)=nan;sw(:,end-numnan+1:end)=nan;
    imagesc(ttt,1:23,sw);
    plot([ttt(1) ttt(end)],[1.5 1.5],'color',[1 1 1],'linewidth',1.5);
    set(gca, 'YDir', 'reverse');
    colormap(cmap2);
    xlabel('Timelag(ms)');ylabel('Subject');
    set(gca,'ytick',[1 2:5:23]);
    set(gca,'YTickLabel',{'sub-02','sub-07','sub-12','sub-17','sub-22','sub-27'});
    set(gca,'fontsize',15);
    set(gcf,'position',pos);
    ylim([0.5 23.5]);
    % print(['fig' filesep namefig 'single'],'-dtiff','-r300');
end
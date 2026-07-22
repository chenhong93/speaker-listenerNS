%% calculate trf for feature-induced SLNS
% init parameters

% TRF parameters
fs_new = 100;
lambda = 1000;
tmin=-2000;
tmax=2000;
trange=[tmin tmax];
numtrange=size(trange,1);
randindall=cell(23,1);
Dir=1;
ft_defaults;
nfold=8;
nstep=1;
speakersource=1:196;
modelall={};
allcorr_singles={};
nums=8;

% seperate index for brain regions
subnum=22;
ntime_show=1;
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
% load significant direct NS mask
load(['res' filesep 'tempmat' filesep 'logrr.mat']);
nreg=length(tempind);
% at least one significant parcel pair
aa=mean(logrr,1);
indnolis=find(aa==1);
aa=mean(logrr,2);
indnospe=find(aa==1);
templog=double(logrr);
temp=zeros(1,size(templog,2));
temp(indnolis)=1;
for i=1:size(logrr,1)
    if ~ismember(i,indnospe)
        templog(i,:)=temp;
    end
end
templog=templog==1;
logrr=templog;% for parcel to region transition


% load feature-induced speaker estimation
temps='sub-02';
tempname = ['SLNS' filesep 'derivatives' filesep 'speaker_estimation' filesep temps filesep temps ...
    '_task-storyretell_combine_source_feature_estimate_meg.mat'];
load(tempname,'data_pred','ffall');

% load speaker significant parcel index
load(['res' filesep 'tempmat' filesep 'indspe_fromSL.mat'],...
    'ind_cal_speaker');
for i=1:22
    modelall={};
    modelall{22,8,length(speakersource)}=[];% prepare memory

    % load listener source MEG
    % listener: 1-22-->sub-07~sub-28
    temps = ['sub-' num2str(floor((i+6)/10)) num2str(mod(i+6,10))];
    tempname = ['SLNS' filesep 'derivatives' filesep 'source_estimate' filesep ...
        temps filesep 'MEG' filesep temps '_task-storylisten_run0'];
    allmeg=cell(nums,1);
    for s=1:nums
        load([tempname num2str(s) '_source_MEG.mat'],'datas','namel','indsource');
        allmeg{s}=datas';
    end
    
    wav=data_pred;
    wavfile=cell(8,1);
    for s=1:8
        temps=wav(:,s);
        tempwav=zeros([size(temps{1,1}) 6]);
        for fea=1:6
            tempwav(:,:,fea)=temps{fea,1};
        end
        wavfile{s,1}=tempwav;
    end
    clear wav;
    
    for chan=1:length(speakersource)
        % use parcels with significant direct NS
        if ind_cal_speaker(chan)==1
            tempnum=length(allmeg);
            tnum=floor(tempnum/nfold);
            tempind=1:8;
            randindall{i,1}=tempind;
            for s=1:8
                % split train and test
                if s~=8
                    indtest=tempind(1+(s-1)*tnum:s*tnum);
                    indtrain=tempind;
                    indtrain(1+(s-1)*tnum:s*tnum)=[];
                else
                    indtest=tempind(1+(s-1)*tnum:end);
                    indtrain=tempind;
                    indtrain(1+(s-1)*tnum:end)=[];
                end
                strain=wavfile(indtrain,1);
                rtrain=allmeg(indtrain,1);
                stest=wavfile(indtest,1);
                rtest=allmeg(indtest,1);

                strain_1=cellfun(@(x) squeeze(x(:,chan,:)), strain, 'UniformOutput', false);
                stest_1=cellfun(@(x) squeeze(x(:,chan,:)), stest, 'UniformOutput', false);
                % Train
                model = mTRFtrain(strain_1,rtrain,fs_new,Dir,tmin,tmax,lambda,'zeropad',1,'type','multi','method','ridge');
                % save model
                modelall{i,s,chan}=model;
                disp(['****_*****_****' num2str(i) '/22--' num2str(s) '/8--' num2str(chan) '/fea' num2str(fea) '****_*****_****']);
            end
        end
    end

    tempt=modelall{i,1,1}.t;
    numt=length(tempt);
    wall=zeros(8,6,196,numt,196);%story-feature-parcel-timelag-parcel
    for ss=1:8
        % wall=zeros(subnum,6,196,numt,196);

        m=squeeze(modelall(i,:,:));%8-196
        tempw=zeros(1,6,196,numt,196);%1-feature-parcel-timelag-parcel
        for n=1:196
            tempm=m(:,n);
            if ~isempty(tempm{ss})
                for s=ss
                    tempw(1,:,n,:,:)=tempm{s}.w;
                end
            end
        end
        wall(ss,:,:,:,:)=squeeze(mean(tempw,1));
    end
    wall=wall(:,:,allind,:,allind);% 22-6-196-401-196
    wreg=zeros(8,6,nreg,nreg,numt);% story-feature-region-region-timelag
    for fff=1:6
        wreg(:,fff,:,:,:)=vertex2reg_gfp(squeeze(wall(:,fff,:,:,:)),logrr,indreg,[]);
    end
    wreg=squeeze(mean(wreg,1));%6-10-10-401
    save(['res' filesep 'feature-drivenNS' filesep temps filesep temps '_featureNS.mat'],...
        'namereg','wreg','ffall','indreg','tempt','showind','tempind','-v7.3');
end


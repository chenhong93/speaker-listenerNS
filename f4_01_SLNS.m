%% calculate speaker-listener NS
% init parameters
% TRF parameters
fs_new = 100;
lambda = 1000;
tmin=-4000;
tmax=4000;
trange=[tmin tmax];% timelag range for r value calculation
numtrange=size(trange,1);
randindall=cell(23,1);
Dir=1;
ft_defaults;
nfold=8;
nstep=1;
speakersource=1:196;
nums=8;

% load speaker MEG source data
tempname = ['SLNS' filesep 'derivatives' filesep 'source_estimate' filesep ...
    'sub-02' filesep 'MEG' filesep 'sub-02_task-storyretell_run0'];
wavfile=cell(8,1);% input for TRF
for s=1:8
    load([tempname num2str(s) '_source_MEG.mat'],'datas','namel','indsource');
    wavfile{s}=datas(speakersource,:)';
end

for i=1:22
    % prepare memory
    modelall={};
    modelall{22,8,length(speakersource)}=[];
    allcorr_singles={};
    allcorr_singles{22,8}=[];
    % listener: 1-22
    % load listener MEG source data
    temps = ['sub-' num2str(floor((i+6)/10)) num2str(mod(i+6,10))];
    tempname = ['SLNS' filesep 'derivatives' filesep 'source_estimate' filesep ...
        temps filesep 'MEG' filesep temps '_task-storylisten_run0'];
    allmeg=cell(nums,1);
    for s=1:nums
        load([tempname num2str(s) '_source_MEG.mat'],'datas','namel','indsource');
        allmeg{s}=datas';
    end
    
    % prepare random index for nfold train/test partition
    tempnum=length(allmeg);
    tnum=floor(tempnum/nfold);
    tempind=randperm(tempnum);
    randindall{i,1}=tempind;
    
    % TRF modeling with leave-1-story-out CV
    parfor s=1:8
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
        
        % TRF model
        tempcorsingle=zeros(size(rtrain{1},2),length(speakersource),numtrange);
        for chan=speakersource
            strain_1=cellfun(@(x) x(:,chan), strain, 'UniformOutput', false);
            stest_1=cellfun(@(x) x(:,chan), stest, 'UniformOutput', false);
            % Train
            model = mTRFtrain(strain_1,rtrain,fs_new,Dir,tmin,tmax,lambda,'zeropad',1,'type','multi','method','ridge');
            modelall{i,s,chan}=model;% save TRF model
            
            % calculate r values for each time range
            for nt=1:numtrange
                % select TRF model according to timelag range
                mm=model;
                tt=mm.t;
                t1=trange(nt,1);t2=trange(nt,2);
                ttabs=abs(tt-t1);ind1=find(ttabs==min(ttabs));
                ttabs=abs(tt-t2);ind2=find(ttabs==min(ttabs));
                mm.t=mm.t(ind1:ind2-1);
                mm.w=mm.w(:,ind1:ind2-1,:);
                % Test
                [~,test] = mTRFpredict(stest_1,rtest,mm,'zeropad',1);
                
                % save r value
                tempcorsingle(:,chan,nt)=squeeze(mean(test.r,1))';
                
            end
            disp(['****_*****_****' num2str(i) '/23--' num2str(s) '/8--' num2str(chan) '****_*****_****']);
        end
        allcorr_singles{i,s}=tempcorsingle;
    end
    save(['res' filesep 'speaker-listenerNS' filesep temps filesep temps '_SLNS.mat'],...
        'trange','modelall','lambda','indsource','speakersource','allcorr_singles','-v7.3');
end


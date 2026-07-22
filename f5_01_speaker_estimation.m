%% calculate trf for amp envelope
% init parameters
% TRF parameters
fs_new = 100;
lambda = 10;
tmin=-1000;
tmax=1000;
Dir=1;
ft_defaults;
nfold=8;
nstep=1;

modelall={};
randindall=cell(23,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% feature to regress
ffall={'acoustic','consonant','vowel','pitch_height','pitch_change','tone'};
data_pred=cell(6,8);
for fff=1:6
    % load one feature
    fean=ffall{fff};
    load([fname '.mat'],'wavfile');

    % load speaker MEG data
    temps = 'sub-02';
    tempname = ['SLNS' filesep 'derivatives' filesep 'source_estimate' filesep ...
        temps filesep 'MEG' filesep temps '_task-storyretell_run0'];
    allmeg=cell(8,1);
    for s=1:8
        load([tempname num2str(s) '_source_MEG.mat'],'datas','namel','indsource');
        allmeg{s}=datas';
    end
    tempind=1:8;
    randindall{23,1}=tempind;
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

        % Train
        model = mTRFtrain(strain,rtrain,fs_new,Dir,tmin,tmax,lambda,'zeropad',1,'type','multi','method','ridge');

        % Test
        [pred,test] = mTRFpredict(stest,rtest,model,'zeropad',1);
        data_pred{fff,indtest}=pred{1,1};
        clear pred;
        disp(['****_*****_****' num2str(23) '/23--' num2str(s) '/8' '****_*****_****']);
    end

end
save(['SLNS' filesep 'derivatives' filesep 'speaker_estimation' filesep temps filesep temps ...
    '_task-storyretell_combine_source_feature_estimate_meg.mat'],...
    'data_pred','ffall','-v7.3');
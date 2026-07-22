%% calculate trf for each feature
% init parameters

% TRF parameters
fs_new = 100;
lambda = 10;
tmin=-500;
tmax=1000;
Dir=1;
nfold=8;
ft_defaults;


for fff=1:6
    % 6 features
    ffall={'acoustic','consonant','vowel','pitch_height','pitch_change','tone'};
    fname=ffall{fff};
    load([fname '.mat'],'wavfile');

    % prepare result variables
    allcorr={};
    modelall={};

    % prepare memory
    allcorr{23,8}=zeros(306,385);
    modelall{23,8}=zeros(306,385);

    for i=1:23
        % listener: 1~22=sub-07~28
        % speaker: 23=sub-02

        % prepare filename
        if i==23
            temps = 'sub-02';
        else
            temps = ['sub-' num2str(floor(i+6/10)) num2str(mod(i+6,10))];
        end
        % load combined preprocessed MEG data
        if i==23
            tempname = ['SLNS' filesep 'derivatives' filesep 'preprocess' filesep temps ...
                filesep temps '_task-storyretell_combine_proc-filt-resam-ICA_meg'];
        else
            tempname = ['SLNS' filesep 'derivatives' filesep 'preprocess' filesep temps ...
                filesep temps '_task-storylisten_combine_proc-filt-resam-ICA_meg'];
        end

        % load data
        load([tempname '.mat'],'allmeg');
        fs=100;

        % prepare random index for nfold train/test partition
        tempnum=length(allmeg);
        tnum=floor(tempnum/nfold);
        tempind=randperm(tempnum);

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
            model = mTRFtrain(strain,rtrain,fs_new,Dir,tmin,tmax,lambda,'zeropad',1,'type','multi');

            % Test
            [~,test] = mTRFpredict(stest,rtest,model,'zeropad',1);

            % save TRF model and r value
            modelall{i,s}=model;
            allcorr{i,s}=mean(test.r,1)';

            clear pred;
            disp(['****_*****_****' num2str(fff) '--' num2str(i) '/23--' num2str(s) '/8' '****_*****_****']);
        end
    end
    save(['res' filesep 'featureTRF' filesep 'feature_TRF_' fname '_combine.mat'],...
        'allcorr','modelall','lambda','fname','-v7.3');
end
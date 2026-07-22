
% Resample rate for ICA calculation
fs_ica = 100;
ft_defaults;
for i=2
    for s=1:8
        % load MEG read/retell rawdata
        temps = ['sub-0' num2str(i)];
        path = ['SLNS' filesep temps filesep ...
            'meg',filesep,temps, '_task-storyread_run-0',num2str(s),'_meg.fif'];
        cfg=[];
        cfg.dataset = (path);
        cfg.continuous = 'yes';
        mat1= ft_preprocessing(cfg);
        fs = mat1.fsample;

        temps = ['sub-0' num2str(i)];%subname{i,1};
        path = ['SLNS' filesep temps filesep ...
            'meg',filesep,temps, '_task-storyretell_run-0',num2str(s),'_meg.fif'];
        cfg=[];
        cfg.dataset = (path);
        cfg.continuous = 'yes';
        mat2= ft_preprocessing(cfg);
        fs = mat2.fsample;

        % combine 2 phase
        mat=mat1;
        mat.time{1,1}=[mat.time{1,1} mat2.time{1,1}];
        mat.trial{1,1}=[mat.trial{1,1} mat2.trial{1,1}];
        mat.sampleinfo=[1 size(mat.trial{1,1},2)];
        clear mat1 mat2;
        
        % bandpass filter: 0.3 to 45Hz
        cfg=[];
        cfg.bpfilter='yes';
        cfg.bpfreq=[0.3 45];
        cfg.bpfiltdir = 'onepass-zerophase';
        cfg.bpfilttype='firws';
        cfg.bpfiltwintype='kaiser';
        mat= ft_preprocessing(cfg, mat);
        
        % detrend
        cfg=[];cfg.detrend='yes';
        mat= ft_preprocessing(cfg, mat);
        
        % ICA calculation
        cfg=[]; cfg.channel={'MEG*1','MEG*2','MEG*3'};
        mat=ft_selectdata(cfg,mat);
        cfg=[]; cfg.resamplefs=fs_ica;
        mat=ft_resampledata(cfg, mat);
        
        cfg=[]; cfg.method='runica';
        meg_ica=ft_componentanalysis(cfg, mat);
        
        % save data of each story
        
        meg_orig=mat;
        % save(['res' filesep 'orig_ICA' filesep temps filesep ...
        %     temps '_s' num2str(s) '_orig1pass.mat'],'meg_orig', '-v7.3');
        % 
        % save(['res' filesep 'orig_ICA' filesep temps filesep ...
        %     temps '_s' num2str(s) '_ica1pass.mat'],'meg_ica', '-v7.3');

    end
end

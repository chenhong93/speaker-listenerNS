%% prepare data for amp envelope
% init parameters

ft_defaults;
% reject ICs selected manually
numica={[1 2 3 13 20 26 27],[1 2 3 12 33 35 68],[1 2 3 12 23 37],[1 2 3 16 20 53 67],...
    [1 2 3 17 49 55],[1 2 3 19 21 25 48],[1 2 3 15 27],[1 2 3 30 31 59]};
ss=zeros(102,8);

i=2;
for s=1:8
    temps = ['sub-0' num2str(i)];%subname{i};
    % read MEG
    tempname=['res' filesep 'orig_ICA' filesep temps filesep ...
            temps '_s' num2str(s) '_'];
    name_icamag=[tempname 'ica1pass.mat'];
    name_origmag=[tempname 'orig1pass.mat'];
    badcomp=numica{s};

    % reject components and project back
    f1 = load(name_origmag);
    f1 = struct2cell(f1);
    cfg=[]; cfg.channel={'MEG*1','MEG*2','MEG*3'};
    data_orig=ft_selectdata(cfg,f1{1,1});

    f2=load(name_icamag);
    ica_mag=f2.meg_ica;
    cfg=[];
    cfg.unmixing  = ica_mag.unmixing;
    cfg.topolabel = ica_mag.topolabel;
    comp_orig     = ft_componentanalysis(cfg, data_orig);

    cfg=[];
    cfg.component = badcomp; % from visual observation
    cfg.updatesens = 'no';
    meg_pure   = ft_rejectcomponent(cfg, comp_orig, data_orig);

    disp([num2str(i) '/22--' num2str(s) '/8']);

    % save clean data after ICA

    % save(['res' filesep 'orig_ICA' filesep temps filesep ...
    %         temps '_s' num2str(s) 'pure1pass.mat'],'meg_pure', '-v7.3');
end



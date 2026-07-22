%% 
% init
i=2;s=1;

temps = 'sub-02';
% load retell onset time of sub-02
load(['SLNS' filesep 'derivatives' filesep 'behavior' filesep temps filesep 'sub-02_retellonset.mat']);
tstart=tstart_all(s);

% load audio recording of sub-02
dd=dir(['SLNS' filesep 'stimuli' filesep 'story_audio' filesep 'sub-02_story' num2str(s) '*.wav']);
fwav=[dd(1).folder filesep dd(1).name];
tt=round(tstart/10);

% extract envelope of sound recording
[y,fs_aud]=audioread(fwav);
y = y(:,1);y=y';
[yupper,ylower] = envelope(y,200,'rms');
yud=resample(yupper,100,fs_aud);

% load MEG data
% original data before ICA
tempname=['res' filesep 'orig_ICA' filesep temps filesep ...
             temps '_s' num2str(s) '_orig1pass.mat'];
load(tempname);
% ICA data
tempname=['res' filesep 'orig_ICA' filesep temps filesep ...
             temps '_s' num2str(s) '_ica1pass.mat'];
load(tempname);
% clean data after ICA
tempname=['res' filesep 'orig_ICA' filesep temps filesep ...
             temps '_s' num2str(s) '_pure1pass.mat'];
load(tempname);

% calculate correlation between MEG and sound envelope
cc_orig=zeros(306,1);
cc_pure=zeros(306,1);
cc_ica=zeros(3,1);
for num=1:306
    tempmeg=meg_orig.trial{1}(num,:);
    megd=tempmeg(tt+1:tt+length(yud));%47700/51500
    cc_orig(num)=corr(megd',yud');

    tempmeg=meg_pure.trial{1}(num,:);
    megd=tempmeg(tt+1:tt+length(yud));%47700/51500
    cc_pure(num)=corr(megd',yud');

    if num<=3
        tempmeg=meg_ica.trial{1}(num,:);
        megd=tempmeg(tt+1:tt+length(yud));%47700/51500
        cc_ica(num)=corr(megd',yud');
    end

end
% average across mag sensors
meanc_orig=mean(mean(cc_orig(1:3:306,1)));
meanc_pure=mean(mean(cc_pure(1:3:306,1)));

%% 
fs=meg_ica.fsample;
% plot sound wave
figure;
tshow=[18.5 43.5];

plot((tshow(1)*fs_aud:tshow(2)*fs_aud-1)/fs_aud,y(1+(tshow(1)*fs_aud):tshow(2)*fs_aud));
title('Sound wave');
xlabel('Time(s)');ylabel('Amplitude');axis tight;
set(gca,'fontsize',15);
set(gcf,'position',[201.0000  328.2000  560.0000  178.4000]);

% plot ICs related to muscle movements, succade, blink
cfg=[]; 
cfg.layout='neuromag306mag_helmet.mat';% use mag layout
pos=[463.400000000000,690.600000000000,1299.20000000000,134.400000000000];
nameic={'muscle','succade','blink'};
for i=1:3
    figure;
    cfg.component = i;
    cfg.colormap='jet';
    ft_topoplotIC(cfg, meg_ica);

    figure;
    tempmeg=meg_ica.trial{1}(i,:);
    plot((tshow(1)*fs:tshow(2)*fs-1)/fs,tempmeg((1+(tshow(1)*fs):tshow(2)*fs)+tt),'k','linewidth',2);
    % title('IC related to musule movement');
    xlabel('Time(s)');ylabel('Amplitude');axis tight;
    axis off;box off;
    set(gca,'fontsize',15);
    set(gcf,'position',pos);

end
for i=1:3
    disp([nameic{i} ': r=' num2str(cc_ica(i))]);
end


%%
figure;

% plot all mag signal before ICA
tempmeg=meg_orig.trial{1}(1:3:306,:);
subplot(2,1,1);
plot((tshow(1)*fs:tshow(2)*fs-1)/fs,tempmeg(:,(1+(tshow(1)*fs):tshow(2)*fs)+tt));
xlim(tshow);ylim([-4e-12 4e-12]);
xlabel('Time(s)');ylabel('Amplitude(T)');
title('Before ICA');
set(gca,'fontsize',15);

% plot all mag signal after ICA
tempmeg=meg_pure.trial{1}(1:3:306,:);
subplot(2,1,2);
plot((tshow(1)*fs:tshow(2)*fs-1)/fs,tempmeg(:,(1+(tshow(1)*fs):tshow(2)*fs)+tt));
xlim(tshow);ylim([-4e-12 4e-12]);
xlabel('Time(s)');ylabel('Amplitude(T)');
title('After ICA');
set(gca,'fontsize',15);
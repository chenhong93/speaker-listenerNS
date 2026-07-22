function addregionline(nametag,showind,nchan)
ntag=length(nametag);
xx=zeros(1,ntag);
for i=1:ntag
    xx(i)=mean(showind{i});
end
set(gca,'XTick',xx,'XTickLabel',nametag);
set(gca,'XTickLabelRotation',45);
set(gca,'YTick',xx,'YTickLabel',nametag);
axis on;
indline=zeros(1,ntag-1);
for i=2:ntag
    indline(i-1)=min(showind{i})-0.5;
end
hold on;
for i=1:length(indline)
    plot([indline(i) indline(i)],[1 nchan],'color',[1 1 1],'linewidth',2);
    plot([1 nchan],[indline(i) indline(i)],'color',[1 1 1],'linewidth',2);
end
xlabel('Listener');ylabel('Speaker');
set(gca,'fontsize',30);
end
%This section creates the wavelet, fourier, and residual components

cd 'F:\Meteor Detections\6.19.20 to 8.12.20 SkyWatch\Confirmed Detections with Spectrograms\Use this Folder for Matlab'

%This installs and establishes paths to codes needed for this code to run
setup_sparse


Fs=100000;

%you will need sparseseparation package for this
%included will be FWSeparate
fig1=figure();
% yW=zeros(524288,2);
% yF=zeros(524288,2);
% yW=zeros(1048576,2);
% yF=zeros(1048576,2);
yW=zeros(2^21,2);
yF=zeros(2^21,2);

for x=1:2
[yW(:,x),yF(:,x)]=FWSeparate(cal_segment(:,x)); 

fig=gcf;
fig.Units='normalized';
fig.OuterPosition=[0 0 1 1];
title('No Humstractor')
subplot(4,2,x)
[S,F,T]=spectrogram(cal_segment(:,x),2048,1024,2048,Fs);
if x==1 
    S_NS_original=abs(S);
else
    S_EW_original=abs(S);
end 
spec=imagesc(T,F/1e3,20*log10(abs(S)));
hcb=colorbar;
hcb.Title.String = "dB(raw)";
%colorbar;
ax = gca;
ax.YDir = 'normal';
caxis([-30 40]);
xlopen=xline(start_event,'r');
xlopen.LineWidth=2;
xlclose=xline(end_event,'r');
xlclose.LineWidth=2;
title('Original')    

subplot(4,2,x+2)
[S,F,T]=spectrogram(yW(:,x),2048,1024,2048,Fs);
if x==1 
    S_NS_wavelet=abs(S);
else
    S_EW_wavelet=abs(S);
end 
spec=imagesc(T,F/1e3,20*log10(abs(S)));
hcb=colorbar;
hcb.Title.String = "dB(raw)";
ax = gca;
ax.YDir = 'normal';
%colorbar;
caxis([-30 40]);
xlopen=xline(start_event,'r');
xlopen.LineWidth=2;
xlclose=xline(end_event,'r');
xlclose.LineWidth=2;
title('Wavelet Components')
 

subplot(4,2,x+4)
[S,F,T]=spectrogram(yF(:,x),2048,1024,2048,Fs);
if x==1 
    S_NS_fourier=abs(S);
else
    S_EW_fourier=abs(S);
end 
spec=imagesc(T,F/1e3,20*log10(abs(S)));
hcb=colorbar;
hcb.Title.String = "dB(raw)";
ax = gca;
ax.YDir = 'normal';
%colorbar;
caxis([-30 40]);
xlopen=xline(start_event,'r');
xlopen.LineWidth=2;
xlclose=xline(end_event,'r');
xlclose.LineWidth=2;
title('Fourier Components')

%residual

%idealresult=cal_segment(1:524288,x)-yW(:,x)-yF(:,x); 
% idealresult=cal_segment(1:1048576,x)-yW(:,x)-yF(:,x);
residual(:,x)=cal_segment(1:2^21,x)-yW(:,x)-yF(:,x);

subplot(4,2,x+6)   
[S,F,T]=spectrogram(residual(:,x),2048,1024,2048,Fs);
if x==1 
    S_NS_residual=abs(S);
else
    S_EW_residual=abs(S);
end 
spec=imagesc(T,F/1e3,20*log10(abs(S)));
hcb=colorbar;
hcb.Title.String = "dB(raw)";
ax = gca;
ax.YDir = 'normal';
%colorbar;
caxis([-30 40]);
xlopen=xline(start_event,'r');
xlopen.LineWidth=2;
xlclose=xline(end_event,'r');
xlclose.LineWidth=2;
title('Residual')

hold on
han=axes(fig1,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Frequency (kHz)');
xaxis=append('Seconds after',' ',finalvlfdate_test,' ','UTC');
[xtitle]=xlabel(han,xaxis);
xtitle.FontSize=14;
%sgtitle('Table Mountain VLF Site NS(left) and EW(right) Spectrograms');
sgtitle('Gunnison Observatory VLF Site NS(left) and EW(right) Spectrograms');        
linkaxes

hold on
end
hold off

%%
% save file
% 
% path1=append('E:\Meteor Detections\8.02.20 to 12.18.20 Gunnison\DataOutput\TimingDelay1_14\FWSeparate\SpectrogramV4\',images(f3).name(1:38),'png');
% 
% saveas(fig1,[path1],'png');
% 
% path2=append('E:\Meteor Detections\8.02.20 to 12.18.20 Gunnison\DataOutput\TimingDelay1_14\FWSeparate\SpectrogramV4\',images(f3).name(1:38),'fig');
% 
% saveas(fig1,[path2],'fig');







%%

fig2=figure(); 

for x=1:2 
    
xtime=length(cal_segment(:,x))/100000;
%xinterval=xtime/524288;
% xinterval=xtime/1048576;
xinterval=xtime/2^21;
xpoints=0:xinterval:xtime;


fig=gcf;
fig.Units='normalized';
fig.OuterPosition=[0 0 1 1];
subplot(4,2,x)
plot(xpoints,cal_segment(:,x))
ax = gca;
ax.YDir = 'normal';
xlopen=xline(start_event,'r');
xlopen.LineWidth=2;
xlclose=xline(end_event,'r');
xlclose.LineWidth=2;
title('Original')
% xlim([0 5.24289])
% xlim([0 10.48576])
xlim([0 2^21/100000])

xtime=length(cal_segment(:,x))/100000;
%xinterval=xtime/524287;
% xinterval=xtime/1048575;
xinterval=xtime/(2^21-1);
xpoints=0:xinterval:xtime;


subplot(4,2,x+2)
plot(xpoints,yW(:,x))
ax.YDir = 'normal';
xlopen=xline(start_event,'r');
xlopen.LineWidth=2;
xlclose=xline(end_event,'r');
xlclose.LineWidth=2;
title('Wavelet Components')
%xlim([0 5.24289])
% xlim([0 10.48576])
xlim([0 2^21/100000])

subplot(4,2,x+4)
plot(xpoints,yF(:,x))
ax.YDir = 'normal';
xlopen=xline(start_event,'r');
xlopen.LineWidth=2;
xlclose=xline(end_event,'r');
xlclose.LineWidth=2;
title('Fourier Components')
%xlim([0 5.24289])
%xlim([0 10.48576])
xlim([0 2^21/100000])

subplot(4,2,x+6)
%plot(xpoints,(cal_segment(1:524288,x)-yW(:,x)-yF(:,x)))
%plot(xpoints,(cal_segment(1:1048576,x)-yW(:,x)-yF(:,x)))
plot(xpoints,(cal_segment(1:2^21,x)-yW(:,x)-yF(:,x)))
ax.YDir = 'normal';
xlopen=xline(start_event,'r');
xlopen.LineWidth=2;
xlclose=xline(end_event,'r');
xlclose.LineWidth=2;
title('Residual')
%xlim([0 5.24289])
%xlim([0 10.48576])
xlim([0 2^21/100000])

han=axes(fig2,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Volts');
xaxis=append('Seconds after',' ',finalvlfdate_test,' ','UTC');
[xtitle]=xlabel(han,xaxis);
xtitle.FontSize=14;
%sgtitle('Table Mountain VLF Site NS(left) and EW(right) Time Series');
sgtitle('Gunnison Observatory VLF Site NS(left) and EW(right) Time Series');

linkaxes


hold on

end

hold off
%%
% save file
% path3=append('E:\Meteor Detections\8.02.20 to 12.18.20 Gunnison\DataOutput\TimingDelay1_14\FWSeparate\TimeSeriesV4\',images(f3).name(1:38),'png');
% 
% saveas(fig2,[path3],'png');
% 
% path4=append('E:\Meteor Detections\8.02.20 to 12.18.20 Gunnison\DataOutput\TimingDelay1_14\FWSeparate\TimeSeriesV4\',images(f3).name(1:38),'fig');
% 
% saveas(fig2,[path4],'fig');
% 
% close all

  %This section calculates the RMS values of the yW and yF and makes plots

%%
%Wavelet Component RMS

% RMS=zeros(524,4);
sizeofRMS=floor(2^21/1000);

RMS=zeros(sizeofRMS,4);
%column 1 is rms values from the NS yW data in 100 data point increments(1
%millisecond)
%column 2 is rms values from the EW yW data in 100 data point increments(1
%millisecond)
%column 3 is rms values from the NS yF data in 100 data point increments(1
%millisecond)
%column 4 is rms values from the EW yW data in 100 data point increments(1
%millisecond)

%%

for c=1:2
%     for x=1:524
    for x=1:sizeofRMS
    RMS(x,c)=rms(yW(1000*x-999:1000*x,c));
    end
end
% end
%%


start_event_data_point=start_event*Fs;
%convert from seconds to data point in cal_segment
end_event_data_point=end_event*Fs;
%convert from seconds to data point in cal_segment
duration_data_points=(start_event_data_point:end_event_data_point);



% xtime=524289/100000;
xtime=2^21/100000;
%length(cal_segment)=524289
% xinterval=xtime/523;
xinterval=xtime/(sizeofRMS-1);
xpoints=0:xinterval:xtime;
%creates an appropriate intervel so the x axis time corresponds with the
%100,000 data points per second rate

fig1=figure()
fig=gcf;
fig.Units='normalized';
fig.OuterPosition=[0 0 1 1];
ax1=subplot(211);
plot(ax1,xpoints,RMS(:,1));
% xlim([0 5.24289]);
xlim([0 2^21/Fs]);
xlopen=xline(start_event,'r');
xlopen.LineWidth=1;
xlclose=xline(end_event,'r');
xlclose.LineWidth=1;


ax2=subplot(212);
plot(ax2,xpoints,RMS(:,2));
% xlim([0 5.24289]);
xlim([0 2^21/Fs]);
xlopen=xline(start_event,'r');
xlopen.LineWidth=1;
xlclose=xline(end_event,'r');
xlclose.LineWidth=1;

han=axes(fig1,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Root Mean Squared');
xaxis=append('Seconds after',' ',finalvlfdate_test,' ','UTC');
xlabel(han,xaxis);
sgtitle('Table Mountain VLF Site NS(top) and EW(bottom) Wavelets RMS')
hold on
linkaxes
hold off
%%
%fill RMS variable

for c=3:4
%     for x=1:524
    for x=1:sizeofRMS
    RMS(x,c)=rms(yF(1000*x-999:1000*x,c-2));
    end
end
% end
%%
%Fourier RMS plots

fig2=figure();
fig=gcf;
fig.Units='normalized';
fig.OuterPosition=[0 0 1 1];
ax1=subplot(211);
plot(ax1,xpoints,RMS(:,3));
% xlim([0 5.24289]);
xlim([0 2^21/Fs]);
xlopen=xline(start_event,'r');
xlopen.LineWidth=1;
xlclose=xline(end_event,'r');
xlclose.LineWidth=1;


ax2=subplot(212);
plot(ax2,xpoints,RMS(:,4));
% xlim([0 5.24289]);
xlim([0 2^21/Fs]);
xlopen=xline(start_event,'r');
xlopen.LineWidth=1;
xlclose=xline(end_event,'r');
xlclose.LineWidth=1;

han=axes(fig2,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel(han,'Root Mean Squared');
xaxis=append('Seconds after',' ',finalvlfdate_test,' ','UTC');
xlabel(han,xaxis);
sgtitle('Table Mountain VLF Site NS(top) and EW(bottom) Fourier RMS')
linkaxes([ax1,ax2],'x')

%%
% 
% path1=append('F:\Meteor Detections SkyWatch\6.19.20 to 8.11.20\Confirmed Detections with Spectrograms\Use this Folder for Matlab\DataOutput\FWSeparate\yWRMS\',images(f3).name(1:38),'png');
% 
% saveas(fig1,[path1],'png');
% 
% path2=append('F:\Meteor Detections SkyWatch\6.19.20 to 8.11.20\Confirmed Detections with Spectrograms\Use this Folder for Matlab\DataOutput\FWSeparate\yWRMS\',images(f3).name(1:38),'fig');
% 
% saveas(fig1,[path2],'fig');
% 
% 
% path3=append('F:\Meteor Detections SkyWatch\6.19.20 to 8.11.20\Confirmed Detections with Spectrograms\Use this Folder for Matlab\DataOutput\FWSeparate\yFRMS\',images(f3).name(1:38),'png');
% 
% saveas(fig2,[path3],'png');
% 
% path4=append('F:\Meteor Detections SkyWatch\6.19.20 to 8.11.20\Confirmed Detections with Spectrograms\Use this Folder for Matlab\DataOutput\FWSeparate\yFRMS\',images(f3).name(1:38),'fig');
% 
% saveas(fig2,[path4],'fig');

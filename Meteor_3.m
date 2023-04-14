 %%NEXT STEPS

%plot histogram function like hist(x,y) (see help) where y is a vector I
%create with the bins I want (like 0.5,0.6,...1.2) we want 20-30 bins 
    
%Provide plots, humstractor, wavelet, fourier, how many meteors with corresponding vlf data,      


%separate into low pass (0-2 khz), then bandpass for (2-4 khz), (4-6khz),
%(6-8 kHz), and (8-10 kHz)
%filter first then subtract the mean. 

% clear all

%Go ahead and add residual RMS

%use eval function for for loop when switching names through iterations

%%
%Establish frequencies

%desired frequency end limit/half sampling freqeuncy (Hz)


for x=1:10
    WN(x)=x*2000/(50000);
end

%%
%Create filters for specific frequency ranges, 0-2,2-4...18-20 kHz

[b(1,1:11),a(1,1:11)]=butter(10,[WN(1)],'low');

for x=2:10
    [b(x,1:11),a(x,1:11)]=butter(5,[WN(x-1) WN(x)]);
end



 %%
%Display filter behavior
% 
% for x=1:10
%     figure; freqz(b(x,1:11),a(x,1:11))
% end

%uncomment if you'd like to see the filter pass


for x=1:10
    hum_new(1:size(cal_removed_noise_data),x*2-1:(x*2))=filter(b(x,:),a(x,:),cal_removed_noise_data); 
end
 

%% Obtain mean for specific frequency range

%Take mean of each column. Therefore left with a single mean value for each
%column, giving a 1x20 variable

for x=1:20
    mean_hum(1,x)=mean(hum_new(1:size(cal_removed_noise_data),x)); 
end

%%

%subtract mean from specific frequency range
for x=1:20
    hum_new_mean_corrected(:,x)=hum_new(:,x)-mean_hum(1,x); 
end

%% Spectrogram Plots

%Uncomment if you want to see spectrogram of the data
%Currently hardcoded to show NS column of yW by choosing column 1

%plots NS and EW of each frequency range. Odd numbered columns in
%hum_new_mean_corrected as NS and even are EW
% for x=1:20
%     figure()
%     [S,F,T]=spectrogram(hum_new_mean_corrected(:,x),2048,1024,2048,Fs);
%     spec=imagesc(T,F/1e3,20*log10(abs(S)));
%     ax = gca;
%     ax.YDir = 'normal';
%     colorbar
%     caxis([-40 30])
%     xlopen=xline(start_event,'r');
%     xlopen.LineWidth=1;
%     xlclose=xline(end_event,'r');
%     xlclose.LineWidth=1;
% end

%%
% for x=1:2
%     figure()
%     plot(hum_new_mean_corrected(:,x))
% end
%% Humstractor RMS plots

%Noise Removed with added butter frequency filter RMS
%column 1 is rms values from the 0-2 kHz NS humstractor data in 100 data point increments(1
%millisecond)
%column 2 is rms values from 0-2 kHz EW humstractor data in 100 data point increments(1
%millisecond)
%column 3 is rms values from the 2-4 kHz NS humstractor data in 100 data
%point incremtns(1 millisecond)
%etc
% RMS=zeros(1048,20);

RMSsamplerate=1000;

sizeofRMS=floor(2^21/RMSsamplerate);

RMS=zeros(sizeofRMS,20);


%RMS sample rate (how many data point used in average), nearest multiple of
%1000 for 2^20,1048000
%x_end=1048000/RMSsamplerate;
x_end=2^21/RMSsamplerate;

%% Obtain RMS values
%Fill RMS variable by taking RMS every RMSsamplerate increment
%Currently hardcoded for just the rms of yW_0_2_new_mean_corrected, in
%order to make it solve for all the frequency ranges, this for loop will
%need to be repeated to create multiple RMSs (in progress atm). Ie copy and past this loop
%and then change the RMS(x,c) into RMS_0_2(x,c), then RMS_2_4(x,c), etc.

for x=1:20
        for y=1:x_end
        startpoint=RMSsamplerate*y-(RMSsamplerate-1);
        endpoint=RMSsamplerate*y;
        RMS(y,x)=rms(hum_new_mean_corrected(startpoint:endpoint,x));
        end
end





%% Humstractor RMS Plots


start_event_data_point=start_event_error_bound*Fs;
%convert from seconds to data point in cal_segment using smaple rate Fs
end_event_data_point=end_event_error_bound*Fs;
%convert from seconds to data point in cal_segment using sample rate Fs
duration_data_points=(start_event_data_point:end_event_data_point);



xtime=(length(cal_removed_noise_data)-1)/100000;
%since length(cal_removed_noise_data)=1048577
xinterval=xtime/(length(RMS)-1);
xpoints=0:xinterval:xtime;
%creates an appropriate intervel so the x axis time corresponds with the
%100,000 data points per second rate
%% Uncomment to see RMS plots
% for x=1:10
% 
% fig1=figure();
% fig=gcf;
% fig.Units='normalized';
% fig.OuterPosition=[0 0 1 1];
% 
% ax(1)=subplot(211);
% semilogy(ax(1),xpoints,RMS(:,x*2-1));
% xlim([0 2^21/100000]);
% xlopen=xline(start_event,'r');
% xlopen.LineWidth=1;
% xlclose=xline(end_event,'r');
% xlclose.LineWidth=1;
% 
% 
% ax(2)=subplot(212);
% semilogy(ax(2),xpoints,RMS(:,x*2));
% xlim([0 2^21/100000]);
% xlopen=xline(start_event,'r');
% xlopen.LineWidth=1;
% xlclose=xline(end_event,'r');
% xlclose.LineWidth=1;
% 
% han=axes(fig1,'visible','off'); 
% han.XLabel.Visible='on';
% han.YLabel.Visible='on';
% ylabel(han,'Root Mean Squared');
% xaxis=append('Seconds after',' ',finalvlfdate_test,' ','UTC');
% xlabel(han,xaxis);
% str=sprintf("Gunnison Observatory VLF Site NS(top) and EW(bottom) RMS between %01d-%01d kHz",x*2-2,x*2);
% sgtitle(str)
% hold on
% linkaxes
% hold off
% 
% end




%% Average RMS value baseline(before) and during and store into variable
for x=1:20
    %the event will always occur at start_event_error_bound*100 in the RMS variable, so
    %baseline always ends at the floor of that (ie if start error bound is
    %1011.15, baseline ends at 1011)
    rms_baseline_and_during(1,x)=mean(RMS(1:floor(start_event_error_bound*100),x));
    %to determine the rms during,first need to calculate when the meteor
    %event ends in the RMS data variable. Since the variable is in
    %increments of 1000 vlf data points, just take the vlf data end event
    %data point and divide by 1000. Then round up to the nearest integer.
    end_rms_point=ceil(end_event_data_point/1000);
    rms_baseline_and_during(2,x)=mean(RMS(ceil(start_event_error_bound*100):end_rms_point,x));
    
    %all the baseline values will be stored in the first row and all the
    %during values will be in the second row, directly below the respective
    %baseline value
end



%% switch here
%cd 'E:\Meteor Detections\8.02.20 to 12.18.20 Gunnison'
%cd 'E:\Meteor Detections\8.02.20 to 12.18.20 Grand Mesa'
load('Meteor_Detection_US0015_Humstractor_Data.mat')
n=length(Meteor_Detection_US0015_Humstractor_Data);


%%

for i=1:n
    if Meteor_Detection_US0015_Humstractor_Data(i).File_Name(7:37)==meteor_filename(7:37);
        duplicate=1;
        break
    else
        duplicate=0; 
    end
end

if duplicate==0;

    fn=fieldnames(Meteor_Detection_US0015_Humstractor_Data);


    Meteor_Detection_US0015_Humstractor_Data(n+1).File_Name=meteor_filename;
    Meteor_Detection_US0015_Humstractor_Data(n+1).Time_of_Event=append(finalmeteortrue_test,' ','UTC');
    Meteor_Detection_US0015_Humstractor_Data(n+1).Duration=duration;
    %NS first and then EW is the order for the variables below
    
    for i=1:10 
        Meteor_Detection_US0015_Humstractor_Data(n+1).(fn{i*3+1})=rms_baseline_and_during(1,i*2-1:i*2);
        Meteor_Detection_US0015_Humstractor_Data(n+1).(fn{i*3+2})=rms_baseline_and_during(2,i*2-1:i*2);

        Meteor_Detection_US0015_Humstractor_Data(n+1).(fn{i*3+3})=Meteor_Detection_US0015_Humstractor_Data(n+1).(fn{i*3+2})./Meteor_Detection_US0015_Humstractor_Data(n+1).(fn{i*3+1});
    end


%     %0-2 kHz
%     Fireball_Detection_Data(n+1).(fn{4})=rms_baseline_and_during(1,1:2);
%     Fireball_Detection_Data(n+1).(fn{5})=rms_baseline_and_during(2,1:2);
% 
%     Fireball_Detection_Data(n+1).(fn{6})=Fireball_Detection_Data(n+1).(fn{5})./Fireball_Detection_Data(n+1).(fn{4});
%     %%
%     %2-4 kHz
%     Fireball_Detection_Data(n+1).(fn{7})=rms_baseline_and_during(1,3:4);
%     Fireball_Detection_Data(n+1).(fn{8})=rms_baseline_and_during(2,3:4);
% 
%     Fireball_Detection_Data(n+1).(fn{9})=Fireball_Detection_Data(n+1).(fn{8})./Fireball_Detection_Data(n+1).(fn{7});
%     %%
%     %4-6 kHz
%     Fireball_Detection_Data(n+1).(fn{10})=rms_baseline_and_during(1,5:6);
%     Fireball_Detection_Data(n+1).(fn{11})=rms_baseline_and_during(2,5:6);
% 
%     Fireball_Detection_Data(n+1).(fn{12})=Fireball_Detection_Data(n+1).(fn{11})./Fireball_Detection_Data(n+1).(fn{10});

end
%% 
savefile='Meteor_Detection_US0015_Humstractor_Data.mat';
save(savefile,'Meteor_Detection_US0015_Humstractor_Data');

%close all




%write script to find ratios above 1,take the file name from that row, and
%then parse through the image directory to then plot that


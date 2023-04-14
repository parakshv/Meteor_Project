%%Humstractor.m needed
function [vlfsite,meteor_filename,new_segment,vlf_filename,cal_segment,cal_removed_noise_data,start_event,end_event,duration,start_event_error_bound,end_event_error_bound,juliandate_meteortrue,juliandate_vlffile,finalvlfdate_test,finalmeteortrue_test,No_Data]=Fireball_1(i,site_num)

%This section obtains the fireball event and determines the time of event,
%the coinciding vlf file, creates the original vlf segment, and creates the
%humstractor segment, it will also make plots of the image and data

cd C:\Users\dinks\Downloads

if site_num==1
    site='Skywatch Observatory'; 
    vlfsite='Table Mountain';
    image_directory='E:\All_Meteor_Detections\us000y\JPGs for Matlab\Fireballs';
    fireballs=readtable('Skywatch Fireballs.xlsx');

elseif site_num==2
    site='Grand Mesa Observatory';
    vlfsite='Gunnison Observatory';
    image_directory='E:\All_Meteor_Detections\us0016\JPGs for Matlab\Fireballs'; 
    fireballs=readtable('Grand Mesa Matlab.xlsx'); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif site_num==3
    site='Gunnison Observatory';
    vlfsite='Gunnison Observatory';
    image_directory='F:\Meteor Detections\8.02.20 to 12.18.20 Gunnison\Images\Fireballs';
    fireballs=readtable('Fireball Times - Sheet4 (2).csv');

    
    %vlf_directory='xxxxx'
    
    %expand these directories because some are still hardcoded, it will
    %require moving files into organized folders for it to be efficient
end



fireballs_array=table2array(fireballs);
%%
%length(fireballs_array)


meteor_filename=char(fireballs_array(i,1));


string_start=char(fireballs_array(i,2));

year=str2num(string_start(1:4));
month=str2num(string_start(6:7));
day=str2num(string_start(9:10));
hour=str2num(string_start(11:12));
minute=str2num(string_start(14:15));
second=str2num(string_start(17:18));
millisecond=str2num(string_start(20:22));
%%
juliandate_starttime=juliandate(year,month,day,hour,minute,second)+millisecond/8.64e7;
%8.64e7 is the number of milliseconds in a day. Since juliandate in matlab
%cant add the milliseconds I have manually added the decimal component to
%the julian date contributed by the milliseconds
%%
string_end=char(fireballs_array(i,3));

a=str2num(string_end(1:4));
b=str2num(string_end(6:7));
c=str2num(string_end(9:10));
d=str2num(string_end(11:12));
e=str2num(string_end(14:15));
f=str2num(string_end(17:18));
g=str2num(string_end(20:22));
%%
juliandate_endtime=juliandate(a,b,c,d,e,f)+g/8.64e7;




%%
%this section is used to find the .mat file corresponding to the meteor
%event
if site_num==1
    folder='J:\Continuous';  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    folder='G:\Continuous';  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

cd(folder)
%dB=dir([datadir '*RM200806065000_000.mat']);
data=dir('*.mat');
%creates variable handle with every file in current folder

%variable handle with only the file names in the folder
numoffiles=size(data);

%stores the date values from the title of each file in the database
filename=[];
for i=1:numoffiles(1,1)
      filename=[filename;data(i).name(3:14)]; 
end

%%
filename_strings=strcat('20',filename);

%%
a=str2num(filename_strings(:,1:4));
b=str2num(filename_strings(:,5:6));
c=str2num(filename_strings(:,7:8));
d=str2num(filename_strings(:,9:10));
e=str2num(filename_strings(:,11:12));
f=str2num(filename_strings(:,13:14));

juliandate_vlfdata=juliandate(a,b,c,d,e,f);


%%

%convert back to numbers again
y=juliandate_vlfdata;
%prevent scientific notation
format long g

%use find function, you want to find file time most prior to the meteortime 
%f=find(y(:,1)<m);
f1=find(y<juliandate_starttime,1,'last');

%f1 and f2 because you actually need last two files(one is the NS and the
%other is EW data file)
f2=f1-1;

juliandate_vlffile=y(f1);

vlf_filename=data(f1,:);

%%

%we know our vlf data snippet will have this many data
%point(needed to be multiple of 2^x for sparseseparation to work as well, 2^19=524288)
% cal_segment=zeros(524289,2);
%2^21 corresponds to about 20.97 seconds (2^21/100000 data points per second)
cal_segment=zeros(2^21+1,2);

%run for loop to create a spectrogram plot for the first file and then the second file
for i=f2:f1
    cd(folder)
    data=dir('*.mat');
    load(data(i).name);

    %% 
    %Calculate time difference between meteor event and spectrogram file

    
    datediff=(juliandate_starttime-juliandate_vlffile)*86400;
    
    if datediff > 600
        disp('Meteor Event occurs more than 10 minutes after the closest previous VLF file from the selected VLF receiver site')
        No_Data=1;

        new_segment=NaN;
        vlf_filename=NaN;
        cal_segment=NaN;
        cal_removed_noise_data=NaN;
        start_event=NaN;
        end_event=NaN;
        duration=NaN;
        start_event_error_bound=NaN;
        end_event_error_bound=NaN;
        juliandate_meteortrue=NaN;
        juliandate_vlffile=NaN;
        finalvlfdate_test=NaN;
        finalmeteortrue_test=NaN;
        No_Data=1;
        
        cd 'F:\Meteor Detections\6.19.20 to 8.12.20 Skywatch\Confirmed Detections with Spectrograms\Use this Folder for Matlab'
        return
    else 
        No_Data=0;
    end
    
%      
%     
%     day_diff=day-start_day;
%     while day_diff~=0
%         disp('ERROR: Check event or file date, event occured 1 or more days away from file')
%         day=input('Enter day that meteor event occured in this format, 6 if the day was Aug 6th \n ');
%         day_diff=day-start_day;
%     end
% 
% 
%     hour_diff=hour-start_hour;
%     while hour_diff~=0
%         disp('Error: Check event or file date, event occured prior to or more than 1 hour from file')
%         hour=input('Enter hour at which meteor event occured in this format, 6 for 06:00:00 UTC \n ');
%         hour_diff=hour-start_hour;
%     end
% 
%     minute_diff=minute-start_minute;
% 
% %     second_diff=second+millisecond/1000+meteor_start_time-start_second;
% 
% 
    second_diff=second+millisecond/1000-start_second;
    %second+millisecond/1000 is the meteor file start time, then the actual meteor start time is
    %added using the detect file information, and then the vlf data start time is subtracted
    %so the second_diff is the difference between the start of the vlf
    %file and the time the meteor occured
    %fireballs do not have a meteor_start_time that need to be added unlike
    %the ff files code
    %% 
    %Convert seconds into frames where 1 second = 100,000 data points
    
    %total_seconds=second_diff+minute_diff*(60);
    total_seconds=(juliandate_starttime-juliandate_vlfdata(i))*86400;
    
    
    %may need to make changes later because milliseconds are included here.
    %Also, want to remove the section above and obtain minute_diff and
    %second_diff from the julian dates rather than the manual math
    
    total_data_points=total_seconds*100000;
    %total theoretical data points between start of vlf raw data file and
    %the detected time of the meteor event

    
    
    %hypothetical, could an error occur if the vlf data does not include
    %the file when going back the 5 second in the next section? my
    %assumption is an error would be there but the code would notify since
    %it couldnt index a negative b value.
    
    %% 
    
    %timing delay for reference and used later when displaying red event lines
    %on plot
    %this is the inherent timing delay of the camera calculated in a gps
    %timing test

    %timing_delay=2.47; %seconds
    timing_delay=.3178; %seconds 
    timing_delay_max=.37; %seconds
    timing_delay_min=.261; %seconds

    %Create new spectrogram segment based on the given time
    b=total_data_points+(2^21)/2;
    %a plus 1 could be added here to prevents an indexing from 0 in new_segment
    %b corresponds to the start of the meteor event IN THE METEOR CAMERA TIME (remember there
    %is an x time delay in the camera so that is why the next step is a subtraction and not
    %an addition. for example, if the camera with detection delay states the 
    %meteor occured at 5:12:35.000, the meteor actually occured at 5:12:)
    %a=b-524288;
    a=b-(2^21);
    %UPDATED: see comment below this one
    %minus 524288 frames(ie ~5 sec) since approximately 2.47 sec timing delay 
    %in camera and the 52488 is factor of 2 which is required for the
    %FWSeparate code
    %what this means is the start of the meteor event always will occur
    %2.47 seconds(ie timing delay) prior to the end of the vlf data segment
    
    %the timing delay was updated to 1.14 seconds. So this means the start
    %of the meteor event will always occur 1.14(ie timing delay) prior to
    %the end of the vlf data segment plot
    
    if b>60000000 
        disp('Check time frame, event segment exceeds available data points in the spectrogram file')
        No_Data=1;
        
        vlf_filename=NaN;
        cal_segment=NaN;
        cal_removed_noise_data=NaN;
        new_segment=NaN;
        start_event=NaN;
        end_event=NaN;
        duration=NaN;
        start_event_error_bound=NaN;
        end_event_error_bound=NaN;
        juliandate_meteortrue=NaN;
        juliandate_vlffile=NaN;
        finalvlfdate_test=NaN;
        finalmeteortrue_test=NaN;



         cd 'F:\Meteor Detections\6.19.20 to 8.12.20 Skywatch\Confirmed Detections with Spectrograms\Use this Folder for Matlab'
        return
    else 
        No_Data=0;
    end
    
    
    if i==f2
        x=1;
    else
        x=2;
    end 
    
    
    new_segment(:,x)=data(a:b);

    
    %%
%calculate duration of meteor event
    
%   new_segment_duration=524288/100000;
    new_segment_duration=length(new_segment(:,x))/100000;

    duration=(juliandate_endtime-juliandate_starttime)*86400; %want it in seconds
    %check this is how julian date works
    
    %do I need to add additional error boundary on duration detected
    %because of the frames?
    
%   start_event=new_segment_duration-timing_delay;
    start_event=new_segment_duration-((length(new_segment(:,x)))/2)/100000-timing_delay;
    
    start_event_error_bound=new_segment_duration-((length(new_segment(:,x)))/2)/100000-timing_delay_max;
    
    
    %start_event gives you how many seconds into the new_segment variable
    %does the meteor event begin
    %as mentioned above, will always occur 2.47 seconds from the end of the
    %vlf data segment (ie 2.77 seconds from the start of the vlf segment)
    
%   end_event=start_event+duration;
    end_event=start_event+duration;
    
    end_event_error_bound=new_segment_duration-((2^21)/2)/100000-timing_delay_min+duration;






    %% 
    %Calibrate segment

    cal_segment(:,x)=new_segment(:,x)*5/32768;
    %%
    %alternative that will replace below section
    
    juliandate_vlfsegment=juliandate_vlfdata(i)+total_seconds/86400-length(new_segment(:,x))/2/100000/86400;
    
    calendarvlfdate=datestr(datetime(juliandate_vlfsegment,'convertfrom','juliandate'));
    
    calendarvlfdate_milliseconds=num2str(juliandate_vlfsegment*86400);
    
    finalvlfdate_test=strcat(calendarvlfdate,calendarvlfdate_milliseconds(13:16))
    
    
    %%

 
    %%
%plot the spectrograms with the powerline noise
%removed

if i==f2
    x=2;
    %NS=f2
    h=figure();
    fig=gcf;
    fig.Units='normalized';
    fig.OuterPosition=[0 0 1 1];
    else x=4;
end 

subplot(2,2,x)

    if i==f2
        x=1;
        %NS=f2
        %new_segment(:,1)=NS
    else
        x=2;
        %EW=f1
        %new_segment(:,2)=EW
    end
    
    cd 'F:\Meteor Detections\6.19.20 to 8.12.20 SkyWatch\Confirmed Detections with Spectrograms\Use this Folder for Matlab'
   
[Output PowerLineSignal WeightedFrequency FrequencyMeasurementTimes]  = Humstractor(new_segment(:,x), Fs, 60, 1/8,1/4,0,0);
removed_noise_data=new_segment(:,x)-PowerLineSignal;


    %Calibrate segment and place in respective column in cal_segment
    %depending on EW or NS

cal_removed_noise_data(:,x)=removed_noise_data*5/32768;

[S,F,T]=spectrogram(cal_removed_noise_data(:,x),2048,1024,2048,Fs);


spec=imagesc(T,F/1e3,20*log10(abs(S)));
ylabel('Frequency (kHz)')
xaxis=append('Seconds after',' ',finalvlfdate_test,' ','UTC');
xlabel(xaxis)
if i==f1
    S_EW_humstractor=abs(S);
    name=append(vlfsite,' ','VLF Site EW Noise Removed')
    title(name)
else
    S_NS_humstractor=abs(S);
    name=append(vlfsite,' ','VLF Site NS Noise Removed')
    title(name)
end 

axis xy;
hcb=colorbar;
hcb.Title.String = "dB(raw)";
%colorbar;
caxis([-30 40]);
%caxis([-60 0]);

xlopen=xline(start_event,'r');
xlopen.LineWidth=2;

% xlopen_sd=xline(start_event_error_bound,'--','Color','#EDB120');
% xlopen_sd.LineWidth=2;

xlclose=xline(end_event,'r');
xlclose.LineWidth=2;

% xlclose_sd=xline(end_event_error_bound,'--','Color','#EDB120');
% xlclose_sd.LineWidth=2;
%spectrogram(cal_segment);
%get (gca,'position')
%set(gca,'position',[0.05 0.01 0.5 0.8])
linkaxes








end

%% 
cd(image_directory)
%%





%dB=dir([datadir '*RM200806065000_000.mat']);
data=dir('*.jpg');
%creates variable handle with every file in current folder

%variable handle with only the file names in the folder
numoffiles=size(data);

%stores the date values from the title of each file in the database
imagenames=[];
for i=1:numoffiles(1,1)
      imagenames=[imagenames;data(i).name(11:25)]; 
end



%%
a=str2num(imagenames(:,1:4)); %year
b=str2num(imagenames(:,5:6)); %month
c=str2num(imagenames(:,7:8)); %days
d=str2num(imagenames(:,10:11)); %hours
e=str2num(imagenames(:,12:13)); %minutes
f=str2num(imagenames(:,14:15)); %seconds

%%
juliandate_images=juliandate(a,b,c,d,e,f);


%%

%convert back to numbers again
y=juliandate_images;
%prevent scientific notation
format long g

%use find function, you want to find file time most prior to the meteortime 

f3=find(y<juliandate_starttime,1,'last');


    %%
    %alternative that will replace below section
    
    juliandate_meteortrue=juliandate_vlfsegment+length(new_segment(:,x))/2/100000/86400-timing_delay/86400;
    
    calendarmeteortrue=datestr(datetime(juliandate_meteortrue,'convertfrom','juliandate'));
    
    calendarmeteortrue_milliseconds=num2str(juliandate_meteortrue*86400);
    
    finalmeteortrue_test=strcat(calendarmeteortrue,calendarmeteortrue_milliseconds(13:16))
    
    %end-4:end

%%

I=imread(data(f3).name);
J=imrotate(I,90);
B=imcrop(J,[430 420 560 680]); %top %left %bottom %right
F=imrotate(B,-90);
subplot(2,2,[1,3]);
imshow(F);
fulltitle=append(site,' ','Meteor Detection',' ',finalmeteortrue_test,' ','UTC');
title(fulltitle);

cd 'F:\Meteor Detections\6.19.20 to 8.12.20 Skywatch\Confirmed Detections with Spectrograms\Use this Folder for Matlab'
end

%%

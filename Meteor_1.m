function [meteor_filename,vlf_filename,cal_segment,cal_removed_noise_data,start_event,end_event,duration,start_event_error_bound,end_event_error_bound,juliandate_meteortrue,juliandate_vlffile,finalvlfdate_test,finalmeteortrue_test,No_Data]=Meteor_1(i,site_num)

%This section obtains the fireball event and determines the time of event,
%the coinciding vlf file, creates the original vlf segment, and creates the
%humstractor segment, it will also make plots of the image and data

if site_num==1
    site='Skywatch Observatory'; 
    image_directory='F:\Meteor Detections\6.19.20 to 8.12.20 Skywatch\Confirmed Detections with Spectrograms\Use this Folder for Matlab\Images'
    cd 'F:\Meteor Detections\6.19.20 to 8.12.20 Skywatch\Confirmed Detections with Spectrograms\Use this Folder for Matlab\Images'
elseif site_num==2
    site='Grand Mesa Observatory';
    image_directory='E:\All_Meteor_Detections\us0016\JPGs for Matlab';
    cd 'E:\All_Meteor_Detections\us0016\JPGs for Matlab'
elseif site_num==3
    site='Gunnison Observatory';
    image_directory='E:\All_Meteor_Detections\us0015\JPGs for Matlab';
    cd 'E:\All_Meteor_Detections\us0015\JPGs for Matlab'
    
    %vlf_directory='xxxxx'
    
    %expand these directories because some are still hardcoded, it will
    %require moving files into organized folders for it to be efficient
end


% fireballs=readtable('Fireball Times - Sheet4 (2).csv');
% 
% fireballs_array=table2array(fireballs);

%filename,starttime,endtime
%%







%%
%variable with only the file names in the folder
images=dir('*.jpg');

%number of files in images variable
numofimagefiles=size(images);

%%
%This section differentiates from V3 because this will grab the month and year so
%any file could be used (V3 only works for August 2020)

%stores full name of each file in the database from the for loop below
imagenamefull_strings=[];

%stores meteor file name equivalent date value from title of each file in
%the database from the for loop below
meteorimagetime_strings=[];


for j=1:numofimagefiles(1)
    %string that will be used to find .mat files
    imagenamefull_strings=[imagenamefull_strings;strcat(images(j).name(11:18),images(j).name(20:25))];
    
    %string used to get the exact meteor event time   
    meteorimagetime_strings=[meteorimagetime_strings;images(j).name(11:29)];
    

end

%%


%year,day,hour,minute,second,millisecond of meteor detection events
meteortime_strings=imagenamefull_strings(:,7:14);


%day,hour,min,sec
meteortime_string=meteortime_strings(i,:);

%'200806' 'yearmonthday'
year_month_day_string=imagenamefull_strings(i,3:8);


year_filename=str2num(meteorimagetime_strings(i,1:4));
month_filename=str2num(meteorimagetime_strings(i,5:6));
day_filename=str2num(meteorimagetime_strings(i,7:8));
hour_filename=str2num(meteorimagetime_strings(i,10:11));
minute_filename=str2num(meteorimagetime_strings(i,12:13));
second_filename=str2num(meteorimagetime_strings(i,14:15));
millisecond_filename=str2num(meteorimagetime_strings(i,17:19));



%we first need the julian date of the filename in which the meteor was
%captured. The filename provides the time at which the file started, but
%not the exact time of the meteor. So the file juliandate is solved below.
%Then, after looking at the detect info files, we can obtain the specific
%frames in which the meteor occured in the file. We convert those to
%seconds and will then add them to the file start time to give the meteor
%event time. Note: the meteor event time at that point will still be
%missing the inherent timing delay value so that will be added in later as
%well.


%%%%REMOVE THE ONE
juliandate_file=juliandate(year_filename,month_filename,day_filename,hour_filename,minute_filename,second_filename)+millisecond_filename/8.64e7;

%%

%%
%this section is to calculate the specific frames in which the meteor
%detection occured in the video file (remember the video files each have 256 frames). 
%This needs to be done in order to add that time delay into the
%calculations since the meteor event time expressed in the file name is not
%specific to the meteor event but rather the start time of the file which
%contains the meteor event.
%This requires searching through the FTPdetect.txt files to obtain which 
%frames the meteor occured in (this means the relevant dated FTPdetect.txt
%files should be in the same folder as this code).

%% switch here

%create directory to parse through of just the .txt files
cd 'F:\Meteor Detections\8.02.20 to 12.18.20 Gunnison\FTPdetectinfo'
%cd 'F:\Meteor Detections\8.02.20 to 12.18.20 Grand Mesa\FTPdetectinfo'
txt=dir('*.txt');

%%


%for loop uses the day_string to identify the FTPdetectinfo file
%the day value is the only one needed since the FTPdetectinfo.txt files are only produced once per a day
for L=1:length(txt)
        %strcmp checks if the year_month_day_string matches any part of the 'txt'
        %files between the characters 24:29. 24:29 correspond to the year month day
        %it only needs to match the to the day it occured since there is only one
        %detect file per day
        tf1=strcmp(txt(L).name(24:29),year_month_day_string);
        %if true tf=1, if false tf=0.
        if tf1==1
            L;
            
            %you can output 'txt(L)' if you want to confirm which FTPdetectinfo.txt
            %file the data is being drawn from.
            
            %when the row with the string is found, the entire file name that 
            %is in that row is saved
            txt_filename=txt(L).name;
        end
end

%opens the detect file with the meteor information
fid=fopen(txt_filename,'r');

% stores the file information in the 'delay' variable
delay=textscan(fid,'%s','Delimiter','\n','CollectOutput',true);



%to find a specific line in 'delay' variable the syntax is 'delay{1}{1,1},delay{1}{2,1},delay{1}{3,1}'


%%
%The following for loop searches through the delay variable for the exact string 
%requested, and once it has been found, it will read the value in the row
%below the one containing the string.
%This is done for all the variables with each following for loop.
 

%this takes the hour,minute,second values from the string based on the jpg
%time stamp we want to match to a given row of FTPdetectinfo.txt  
%for example delay{1}{80}(20:25) outputs 025449 (that is the hour minute
%and seconds of the meteor event from the individual file name)

%meteortime_string(3:8) is the hour,minute,and second of the event. Day is
%not needed since the detect file for that specific year,month,day has already
%been selected as the delay file.
s=meteortime_string(3:8);
    
    for K=1:length(delay{1})
        
        %strcmp will not work if the index is exceeded, so this ensures
        %there are enough characters in the row so that strcmp does not
        %return an error and only checks the rows where there are
        %enough characters
        if strlength(delay{1}{K})>24
            
            %strcmp checks if the s string matches any part of the 'delay'
            %file between the characters 20:25 in every row with atleast 25
            %characters.
            %if true tf2=1, if false tf2=0.
            tf2=strcmp(delay{1}{K}(20:25), s);

            if tf2==1
                %you can output K if you want to confirm which line of
                %'delay' the data is being drawn from
                K
                %when the string is found, this tells the code to go 3 rows
                %below that because that is where the meteor detection
                %frame
                %is found
                row=K+3;
                
                %the first six numbers of that row contain the frame it
                %occured (decimals are included, not sure why frames are
                %divided into decimals however)
                meteor_start_frame_string=delay{1}{row}(1:6);
            end
        end
    end
    

%convert to number for duration calculations
meteor_start_frame=str2num(meteor_start_frame_string);    

%convert frame to seconds @25fps
%this is the time that passed between the start of the meteor file
%timestamp and the start of the meteor event
meteor_start_time=meteor_start_frame/25;    



%%
%this section searches through the FTPdetect.txt file again to find the meteor event end frame 
%and to solve the duration of the meteor event 
%the duration will be used to adjust the red line markers on the output
%spectrogram to have an accurate area of interest


%looking at the delay variable (which is just the FTPdetectinfo.txt file compiled as noted before), 
%it can be seen that after it lists which frames the meteor occured in,
%it is always followed with a line break '--------------' or in the case
%of the last detection in the file, it is just an empty row. What is done 
%here is s1 and s2 are the string for just the first character of those scenarios,
%either a hyphen or a space. And the for loop below will tell the 
%script to search for the first instance of either s1 or s2 following the 
%first line indicating what frame the meteor was detected (That line was solved earlier
%above in the code and is the variable 'row')
s1='-';
s2=' ';


%256 chosen since maximum video length is 256 frames max (10 seconds), ie a
%meteor occuring the entire video segment
    for M=1:256
            frames=row+M;
            if frames == length(delay{1})
                    lastframe=frames;
                    meteor_end_frame_string=delay{1}{lastframe}(1:7);
                    break 
            else    
            tf4=strcmp(delay{1}{frames}(1), s2);
            tf3=strcmp(delay{1}{frames}(1), s1);
            %strcmp checks if the s string matches a row following the start
            %of the meteor detection time in 'delay'
            %the first row detected that matches the string s1 indicates the
            %last frame detection has passed and the frame information is
            %found in the row above (see the delay variable to see this)
            %if true tf=1, if false tf=0.
            
            
            %tf4 is included because there is an exception to the
            %hyphen rule utilized for s1. If the meteor is the last
            %detection in the file, then it will be blank space, not a
            %hypen. So tf4 handles this situation.
            
            
            if tf3==1 || tf4==1
                break
            end
                %you can output M if you want to confirm which line of
                %'delay' the data is being drawn from
                M;
                
                %when the string is found, this tells the code to get
                %the frame string in that row
                lastframe=frames;
                meteor_end_frame_string=delay{1}{lastframe}(1:7);
                
            end
    end  
    
  
%convert to number for duration calculations
meteor_end_frame=str2num(meteor_end_frame_string);    

%convert frame to seconds @25fps
%this is the time that passed between the start of the meteor file
%timestamp and the end of meteor event
meteor_end_time=meteor_end_frame/25;    







%%
%length(fireballs_array)


meteor_filename=char(images(i).name);



%%
juliandate_starttime=juliandate_file+meteor_start_time/8.64e4;
%8.64e7 is the number of milliseconds in a day. Since juliandate in matlab
%cant add the milliseconds I have manually added the decimal component to
%the julian date contributed by the milliseconds
%%

juliandate_endtime=juliandate_file+meteor_end_time/8.64e4;




%%
%this section is used to find the .mat file corresponding to the meteor
%event

cd 'G:\Continuous'

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
    cd 'G:\Continuous'
    data=dir('*.mat');
    load(data(i).name);

    %% 
    %Calculate time difference between meteor event and spectrogram file

    
    datediff=(juliandate_starttime-juliandate_vlffile)*86400;
    
    if datediff > 600
        disp('Meteor Event occurs more than 10 minutes after the closest previous VLF file from the selected VLF receiver site')
        No_Data=1;

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
%     second_diff=second+millisecond/1000-start_second;
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
    
    if a<=0
        disp('Event segment spans across two vlf spectrogram files and has been omitted')
        No_Data=1;
        
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

         cd 'F:\Meteor Detections\6.19.20 to 8.12.20 Skywatch\Confirmed Detections with Spectrograms\Use this Folder for Matlab'
        return
    else 
        No_Data=0;
    end

    
    
    if b>length(data) 
        disp('Check time frame, event segment exceeds available data points in the spectrogram file')
        No_Data=1;
        
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

         cd 'F:\Meteor Detections\6.19.20 to 8.12.20 Skywatch\Confirmed Detections with Spectrograms\Use this Folder for Matlab'
        return
    else 
        No_Data=0;
    end

    
    new_segment=data(a:b);

    
    %%
%calculate duration of meteor event
    
%   new_segment_duration=524288/100000;
    new_segment_duration=length(new_segment)/100000;

    duration=(juliandate_endtime-juliandate_starttime)*86400; %want it in seconds
    %check this is how julian date works
    
    %do I need to add additional error boundary on duration detected
    %because of the frames?
    
%   start_event=new_segment_duration-timing_delay;
    start_event=new_segment_duration-((length(new_segment))/2)/100000-timing_delay;
    
    start_event_error_bound=new_segment_duration-((length(new_segment))/2)/100000-timing_delay_max;
    
    
    %start_event gives you how many seconds into the new_segment variable
    %does the meteor event begin
    %as mentioned above, will always occur 2.47 seconds from the end of the
    %vlf data segment (ie 2.77 seconds from the start of the vlf segment)
    
%   end_event=start_event+duration;
    end_event=start_event+duration;
    
    end_event_error_bound=new_segment_duration-((2^21)/2)/100000-timing_delay_min+duration;






    %% 
    %Calibrate segment
    if i==f2
    x=1;
    else x=2;
    end 
    cal_segment(:,x)=new_segment*5/32768;
    %%
    %alternative that will replace below section
    
    juliandate_vlfsegment=juliandate_vlfdata(i)+total_seconds/86400-length(new_segment)/2/100000/86400;
    
    calendarvlfdate=datestr(datetime(juliandate_vlfsegment,'convertfrom','juliandate'));
    
    calendarvlfdate_milliseconds=num2str(juliandate_vlfsegment*86400);
    
    if length(calendarvlfdate_milliseconds)==14
        finalvlfdate_test=strcat(calendarvlfdate,calendarvlfdate_milliseconds(13:14))
    elseif length(calendarvlfdate_milliseconds)==15
        finalvlfdate_test=strcat(calendarvlfdate,calendarvlfdate_milliseconds(13:15))
    else
        finalvlfdate_test=strcat(calendarvlfdate,calendarvlfdate_milliseconds(13:16))
    end
    
    
    
    %%
%     yearmonth=append(string_start(1:4),' ',string_start(6:7));
%     day_string=string_start(9:10);
%     hour_string=string_start(11:12);
%     minute_string=string_start(14:15);
%     colon=':';
%     if second_diff<new_segment_duration/2
%         truevlfsecond=second_diff+60-new_segment_duration/2;
%         truevlfminute=minute-1;
%         truevlfsecond_string=sprintf( '%0.5g', truevlfsecond ); 
%         truevlfminute_string=sprintf( '%d', truevlfminute );
%         fullvlfdate=append(yearmonth,' ',day_string,' ',hour_string,colon,truevlfminute_string,colon,truevlfsecond_string);
%         finalvlfdate=datestr(fullvlfdate,'mmmm.dd,yyyy HH:MM:SS.FFF')
%     else 
%     truevlfsecond=second_diff-new_segment_duration/2;
%     truevlfsecond_string=sprintf('%0.5g',truevlfsecond); 
%     fullvlfdate=append(yearmonth,' ',day_string,' ',hour_string,colon,minute_string,colon,truevlfsecond_string);
%     finalvlfdate=datestr(fullvlfdate,'mmm.dd,yyyy HH:MM:SS.FFF')
%     end 
%  
    %%
%plot the spectrograms with the powerline noise
%removed

if i==f2
    x=2;
    h=figure();
    fig=gcf;
    fig.Units='normalized';
    fig.OuterPosition=[0 0 1 1];
    else x=4;
end 

cd 'F:\Meteor Detections\6.19.20 to 8.12.20 SkyWatch\Confirmed Detections with Spectrograms\Use this Folder for Matlab'


[Output PowerLineSignal WeightedFrequency FrequencyMeasurementTimes]  = Humstractor(new_segment, Fs, 60, 1,1/4,0,0);
subplot(2,2,x)
removed_noise_data=new_segment-PowerLineSignal;


    %Calibrate segment and place in respective column in cal_segment
    %depending on EW or NS
    if i==f2
        x=1;
    else
        x=2;
    end 

cal_removed_noise_data(:,x)=removed_noise_data*5/32768;

[S,F,T]=spectrogram(cal_removed_noise_data(:,x),2048,1024,2048,Fs);

spec=imagesc(T,F/1e3,20*log10(abs(S)));
ylabel('Frequency (kHz)')
xaxis=append('Seconds after',' ',finalvlfdate_test,' ','UTC');
xlabel(xaxis,'FontSize',18)
if i==f1
    S_EW_humstractor=abs(S);
    name=append(site,' ','VLF Site EW Noise Removed')
    title(name,'FontSize',18)
else
    S_NS_humstractor=abs(S);
    name=append(site,' ','VLF Site NS Noise Removed')
    title(name,'FontSize',18)
end 

axis xy;
hcb=colorbar;
hcb.Title.String = "dB(raw)";
%colorbar;
caxis([-30 25]);

xlopen=xline(start_event,'r');
xlopen.LineWidth=2;

xlopen_sd=xline(start_event_error_bound,'--','Color','#EDB120');
xlopen_sd.LineWidth=2;

xlclose=xline(end_event,'r');
xlclose.LineWidth=2;

xlclose_sd=xline(end_event_error_bound,'--','Color','#EDB120');
xlclose_sd.LineWidth=2;
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
    
    juliandate_meteortrue=juliandate_vlfsegment+length(new_segment)/2/100000/86400-timing_delay/86400;
    
    calendarmeteortrue=datestr(datetime(juliandate_meteortrue,'convertfrom','juliandate'));
    
    calendarmeteortrue_milliseconds=num2str(juliandate_meteortrue*86400);
    
    if length(calendarmeteortrue_milliseconds)==14
         finalmeteortrue_test=strcat(calendarmeteortrue,calendarmeteortrue_milliseconds(13:14))
    elseif length(calendarmeteortrue_milliseconds)==15
         finalmeteortrue_test=strcat(calendarmeteortrue,calendarmeteortrue_milliseconds(13:15))
    else
        finalmeteortrue_test=strcat(calendarmeteortrue,calendarmeteortrue_milliseconds(13:16))
    end
    
    

%%
%create a corrected date to be included into the title based on the user inputs
%note yearmonth will need to be updated


% yearmonth=append(imagenames(f3,1:4),' ',imagenames(f3,5:6));
% colon=':';
% period='.';
% if second_diff<timing_delay
%         truemeteorsecond=second_diff+60-timing_delay;
%         truemeteorminute=minute-1;
%         truemeteorsecond_string=sprintf( '%0.5g', truemeteorsecond ); 
%         truemeteorminute_string=sprintf( '%d', truemeteorminute );
%         fullmeteordate=append(yearmonth,' ',day_string,' ',hour_string,colon,truemeteorminute_string,colon,truemeteorsecond_string)
%         finalmeteordate=datestr(fullmeteordate,'mmm.dd,yyyy HH:MM:SS.FFF');
%     else 
% truemeteorsecond=second_diff-timing_delay;
% truemeteorsecond_string=sprintf( '%0.5g', truemeteorsecond ); 
% fullmeteordate=append(yearmonth,' ',day_string,' ',hour_string,colon,minute_string,colon,truemeteorsecond_string);
% finalmeteordate=datestr(fullmeteordate,'mmm.dd,yyyy HH:MM:SS.FFF')
% end 
I=imread(data(f3).name);
J=imrotate(I,90);
B=imcrop(J,[430 420 560 680]); %top %left %bottom %right
F=imrotate(B,-90);
subplot(2,2,[1,3]);
imshow(F);
fulltitle=append(site,' ','Meteor Detection',' ',finalmeteortrue_test,' ','UTC');
title(fulltitle,'FontSize',18);

cd 'F:\Meteor Detections\6.19.20 to 8.12.20 Skywatch\Confirmed Detections with Spectrograms\Use this Folder for Matlab'
end

%%
% save file
%path1=append('E:\Meteor Detections\6.19.20 to 8.12.20 SkyWatch\Confirmed Detections with Spectrograms\Use this Folder for Matlab\DataOutput\TimingDelay0_325\',images(f3).name(1:38),'png');
% 
% saveas(h,[path1],'png');
% 
% path2=append('E:\Meteor Detections\6.19.20 to 8.12.20 SkyWatch\Confirmed Detections with Spectrograms\Use this Folder for Matlab\DataOutput\TimingDelay1_14\HumstractorwithimageV4\',images(f3).name(1:38),'fig');
% 
% saveas(h,[path2],'fig');
% 
% disp('Images saved');
% 
% close all
%save image files
%find corresponding lightning by looking at date of file (or actually just
%use the fireball sheets excel document) 

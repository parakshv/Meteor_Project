clear all

%uncomment to save all plots and spreadsheets
%sf=1;
sf=0;



cd C:\Users\dinks\Downloads

%%
%set which fireball data you want to use, either site us000y,us0016,or
%us0015

%Skywatch (us000y):
%site_num=1;
%fireballs=readtable('Skywatch Fireballs.xlsx');

%Grand Mesa (us0016):
%site_num=2;
%fireballs=readtable('Grand Mesa Matlab.xlsx');

%Gunnison (us0015):
site_num=3;
fireballs=readtable('Fireball Times - Sheet4 (2).csv');



%%
fireballs_array=table2array(fireballs);

%%

cd 'F:\Meteor Detections\6.19.20 to 8.12.20 Skywatch\Confirmed Detections with Spectrograms\Use this Folder for Matlab'

%do not start from 1 as that is the variable title row, so start with 2
for k=32
[vlfsite,meteor_filename,new_segment,vlf_filename,cal_segment,cal_removed_noise_data,start_event,end_event,duration,start_event_error_bound,end_event_error_bound,juliandate_meteortrue,juliandate_vlffile,finalvlfdate_test,finalmeteortrue_test,No_Data]=Fireball_1(k,site_num);

    if sf==1
        %following segment will put in NaN into the datasheet if the relevant
        %vlf data cannot be found for data analysis 
        if isnan(cal_segment)


            %% switch here
            %cd 'E:\Meteor Detections\8.02.20 to 12.18.20 Gunnison'
            %cd 'E:\Meteor Detections\8.02.20 to 12.18.20 Grand Mesa'

            if site_num==1
                load('Fireball_Detection_US000Y_Humstractor_Data.mat')
                load('Fireball_Detection_US000Y_Fourier_Data.mat')
                load('Fireball_Detection_US000Y_Wavelet_Data.mat')
                load('Fireball_Detection_US000Y_Residual_Data.mat')
                sheet(:,:,1)=Fireball_Detection_US000Y_Humstractor_Data;
                sheet(:,:,2)=Fireball_Detection_US000Y_Fourier_Data;
                sheet(:,:,3)=Fireball_Detection_US000Y_Wavelet_Data;
                sheet(:,:,4)=Fireball_Detection_US000Y_Residual_Data;
            elseif site_num==2
                load('Fireball_Detection_US0016_Humstractor_Data.mat')
                load('Fireball_Detection_US0016_Fourier_Data.mat')
                load('Fireball_Detection_US0016_Wavelet_Data.mat')
                load('Fireball_Detection_US0016_Residual_Data.mat')
                sheet(:,:,1)=Fireball_Detection_US0016_Humstractor_Data;
                sheet(:,:,2)=Fireball_Detection_US0016_Fourier_Data;
                sheet(:,:,3)=Fireball_Detection_US0016_Wavelet_Data;
                sheet(:,:,4)=Fireball_Detection_US0016_Residual_Data;
            elseif site_num==3
                load('Fireball_Detection_US0015_Humstractor_Data.mat')
                load('Fireball_Detection_US0015_Fourier_Data.mat')
                load('Fireball_Detection_US0015_Wavelet_Data.mat')
                load('Fireball_Detection_US0015_Residual_Data.mat')
                sheet(:,:,1)=Fireball_Detection_US0015_Humstractor_Data;
                sheet(:,:,2)=Fireball_Detection_US0015_Fourier_Data;
                sheet(:,:,3)=Fireball_Detection_US0015_Wavelet_Data;
                sheet(:,:,4)=Fireball_Detection_US0015_Residual_Data;
            end



            for z=1:4

                datasheet=sheet(:,:,z);

                n=length(datasheet);



                %%

                for j=1:n
                    if datasheet(j).File_Name(7:37)==meteor_filename(7:37);
                        duplicate=1;
                        break
                    else
                        duplicate=0; 
                    end
                end

                if duplicate==0;

                    fn=fieldnames(datasheet);


                    datasheet(n+1).File_Name=meteor_filename;
                    datasheet(n+1).Time_of_Event=finalmeteortrue_test;
                    datasheet(n+1).Duration=duration;
                    %NS first and then EW is the order for the variables below

                    for j=1:10 
                        datasheet(n+1).(fn{j*3+1})=NaN;
                        datasheet(n+1).(fn{j*3+2})=NaN;

                        datasheet(n+1).(fn{j*3+3})=NaN;
                    end

                end
                %% 

                if site_num==1
                    if z==1
                        Fireball_Detection_US000Y_Humstractor_Data=datasheet;
                        savefile='Fireball_Detection_US000Y_Humstractor_Data.mat';
                        save(savefile,'Fireball_Detection_US000Y_Humstractor_Data');
                    elseif z==2
                        Fireball_Detection_US000Y_Fourier_Data=datasheet;
                        savefile='Fireball_Detection_US000Y_Fourier_Data.mat';
                        save(savefile,'Fireball_Detection_US000Y_Fourier_Data');     
                    elseif z==3
                        Fireball_Detection_US000Y_Wavelet_Data=datasheet;
                        savefile='Fireball_Detection_US000Y_Wavelet_Data.mat';
                        save(savefile,'Fireball_Detection_US000Y_Wavelet_Data');

                    elseif z==4
                        Fireball_Detection_US000Y_Residual_Data=datasheet;
                        savefile='Fireball_Detection_US000Y_Residual_Data.mat';
                        save(savefile,'Fireball_Detection_US000Y_Residual_Data'); 
                    end

                elseif site_num==2  
                    if z==1
                        Fireball_Detection_US0016_Humstractor_Data=datasheet;
                        savefile='Fireball_Detection_US0016_Humstractor_Data.mat';
                        save(savefile,'Fireball_Detection_US0016_Humstractor_Data');           
                    elseif z==2
                        Fireball_Detection_US0016_Fourier_Data=datasheet;
                        savefile='Fireball_Detection_US0016_Fourier_Data.mat';
                        save(savefile,'Fireball_Detection_US0016_Fourier_Data');     
                    elseif z==3
                        Fireball_Detection_US0016_Wavelet_Data=datasheet;
                        savefile='Fireball_Detection_US0016_Wavelet_Data.mat';
                        save(savefile,'Fireball_Detection_US0016_Wavelet_Data');       
                    elseif z==4
                        Fireball_Detection_US0016_Residual_Data=datasheet;
                        savefile='Fireball_Detection_US0016_Residual_Data.mat';
                        save(savefile,'Fireball_Detection_US0016_Residual_Data'); 
                    end

                elseif site_num==3
                    if z==1
                        Fireball_Detection_US0015_Humstractor_Data=datasheet;
                        savefile='Fireball_Detection_US0015_Humstractor_Data.mat';
                        save(savefile,'Fireball_Detection_US0015_Humstractor_Data');             
                    elseif z==2
                        Fireball_Detection_US0015_Fourier_Data=datasheet;
                        savefile='Fireball_Detection_US0015_Fourier_Data.mat';
                        save(savefile,'Fireball_Detection_US0015_Fourier_Data');

                    elseif z==3
                        Fireball_Detection_US0015_Wavelet_Data=datasheet;
                        savefile='Fireball_Detection_US0015_Wavelet_Data.mat';
                        save(savefile,'Fireball_Detection_US0015_Wavelet_Data');

                    elseif z==4
                        Fireball_Detection_US0015_Residual_Data=datasheet;
                        savefile='Fireball_Detection_US0015_Residual_Data.mat';
                        save(savefile,'Fireball_Detection_US0015_Residual_Data'); 
                    end
                end


            end

            clear sheet 

            continue
        end


    end
Fireball_2


Fireball_3

%Fireball_3_Fourier

%Fireball_3_Wavelet

%Fireball_3_Residual




end
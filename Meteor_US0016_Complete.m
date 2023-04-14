clear all


cd 'E:\All_Meteor_Detections\us0016\JPGs for Matlab'

%variable with only the file names in the folder
images=dir('*.jpg');

%number of files in images variable
numofimagefiles=size(images);

%%

cd 'F:\Meteor Detections\6.19.20 to 8.12.20 Skywatch\Confirmed Detections with Spectrograms\Use this Folder for Matlab'


for k=71
[meteor_filename,vlf_filename,cal_segment,cal_removed_noise_data,start_event,end_event,duration,start_event_error_bound,end_event_error_bound,juliandate_meteortrue,juliandate_vlffile,finalvlfdate_test,finalmeteortrue_test,No_Data]=Meteor_US0016_1(k,2);



    if isnan(cal_segment)
        
      
        %% switch here
        %cd 'E:\Meteor Detections\8.02.20 to 12.18.20 Gunnison'
        %cd 'E:\Meteor Detections\8.02.20 to 12.18.20 Grand Mesa'
        load('Meteor_Detection_US0016_Humstractor_Data.mat')
        n=length(Meteor_Detection_US0016_Humstractor_Data);


        %%

        for j=1:n
            if Meteor_Detection_US0016_Humstractor_Data(j).File_Name(7:37)==meteor_filename(7:37);
                duplicate=1;
                break
            else
                duplicate=0; 
            end
        end

        if duplicate==0;

            fn=fieldnames(Meteor_Detection_US0016_Humstractor_Data);


            Meteor_Detection_US0016_Humstractor_Data(n+1).File_Name=meteor_filename;
            Meteor_Detection_US0016_Humstractor_Data(n+1).Time_of_Event=finalmeteortrue_test;
            Meteor_Detection_US0016_Humstractor_Data(n+1).Duration=duration;
            %NS first and then EW is the order for the variables below

            for j=1:10 
                Meteor_Detection_US0016_Humstractor_Data(n+1).(fn{j*3+1})=NaN;
                Meteor_Detection_US0016_Humstractor_Data(n+1).(fn{j*3+2})=NaN;

                Meteor_Detection_US0016_Humstractor_Data(n+1).(fn{j*3+3})=NaN;
            end

        end
        %% 
        savefile='Meteor_Detection_US0016_Humstractor_Data.mat';
        save(savefile,'Meteor_Detection_US0016_Humstractor_Data');

        %%
        
        load('Meteor_Detection_US0016_Fourier_Data.mat')
        n=length(Meteor_Detection_US0016_Fourier_Data);

        for j=1:n
            if Meteor_Detection_US0016_Fourier_Data(j).File_Name(7:37)==meteor_filename(7:37);
                duplicate=1;
                break
            else
                duplicate=0; 
            end
        end

        if duplicate==0;

            fn=fieldnames(Meteor_Detection_US0016_Fourier_Data);


            Meteor_Detection_US0016_Fourier_Data(n+1).File_Name=meteor_filename;
            Meteor_Detection_US0016_Fourier_Data(n+1).Time_of_Event=finalmeteortrue_test;
            Meteor_Detection_US0016_Fourier_Data(n+1).Duration=duration;
            %NS first and then EW is the order for the variables below

            for j=1:10 
                Meteor_Detection_US0016_Fourier_Data(n+1).(fn{j*3+1})=NaN;
                Meteor_Detection_US0016_Fourier_Data(n+1).(fn{j*3+2})=NaN;

                Meteor_Detection_US0016_Fourier_Data(n+1).(fn{j*3+3})=NaN;
            end

        end
        
        savefile='Meteor_Detection_US0016_Fourier_Data.mat';
        save(savefile,'Meteor_Detection_US0016_Fourier_Data');

                %%
        
        load('Meteor_Detection_US0016_Wavelet_Data.mat')
        n=length(Meteor_Detection_US0016_Wavelet_Data);

        for j=1:n
            if Meteor_Detection_US0016_Wavelet_Data(j).File_Name(7:37)==meteor_filename(7:37);
                duplicate=1;
                break
            else
                duplicate=0; 
            end
        end

        if duplicate==0;

            fn=fieldnames(Meteor_Detection_US0016_Wavelet_Data);


            Meteor_Detection_US0016_Wavelet_Data(n+1).File_Name=meteor_filename;
            Meteor_Detection_US0016_Wavelet_Data(n+1).Time_of_Event=finalmeteortrue_test;
            Meteor_Detection_US0016_Wavelet_Data(n+1).Duration=duration;
            %NS first and then EW is the order for the variables below

            for j=1:10 
                Meteor_Detection_US0016_Wavelet_Data(n+1).(fn{j*3+1})=NaN;
                Meteor_Detection_US0016_Wavelet_Data(n+1).(fn{j*3+2})=NaN;

                Meteor_Detection_US0016_Wavelet_Data(n+1).(fn{j*3+3})=NaN;
            end

        end
        
        savefile='Meteor_Detection_US0016_Wavelet_Data.mat';
        save(savefile,'Meteor_Detection_US0016_Wavelet_Data');

                %%
        
        load('Meteor_Detection_US0016_Residual_Data.mat')
        n=length(Meteor_Detection_US0016_Residual_Data);

        for j=1:n
            if Meteor_Detection_US0016_Residual_Data(j).File_Name(7:37)==meteor_filename(7:37);
                duplicate=1;
                break
            else
                duplicate=0; 
            end
        end

        if duplicate==0;

            fn=fieldnames(Meteor_Detection_US0016_Residual_Data);


            Meteor_Detection_US0016_Residual_Data(n+1).File_Name=meteor_filename;
            Meteor_Detection_US0016_Residual_Data(n+1).Time_of_Event=finalmeteortrue_test;
            Meteor_Detection_US0016_Residual_Data(n+1).Duration=duration;
            %NS first and then EW is the order for the variables below

            for j=1:10 
                Meteor_Detection_US0016_Residual_Data(n+1).(fn{j*3+1})=NaN;
                Meteor_Detection_US0016_Residual_Data(n+1).(fn{j*3+2})=NaN;

                Meteor_Detection_US0016_Residual_Data(n+1).(fn{j*3+3})=NaN;
            end

        end
        
        savefile='Meteor_Detection_US0016_Residual_Data.mat';
        save(savefile,'Meteor_Detection_US0016_Residual_Data');

        continue
    end



Meteor_US0016_2;


Meteor_US0016_3;

Meteor_US0016_3_Fourier;

Meteor_US0016_3_Wavelet;

Meteor_US0016_3_Residual;

close all

end
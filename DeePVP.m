function DeePVP
% The main program of the complete DeePVP, including the PVP identification and PVP classification.
[file,path]=uigetfile('*','Select an input file for DeePVP');

SeqFile=[path,file];
ResultFile=[path,file,'.DeePVP.csv'];

if exist([pwd,'/two_class.csv'])
    cmd=['rm -f ',pwd,'/two_class.csv'];
    unix(cmd);
end

if exist([pwd,'/ten_class.csv'])
    cmd=['rm -f ',pwd,'/ten_class.csv'];
    unix(cmd);
end

DeePVP_m(SeqFile,[pwd,'/two_class.csv'])  % Run the main module of DeePVP for PVP identification.
DeePVP_e(SeqFile,[pwd,'/ten_class.csv'])  % Run the extended module of DeePVP for PVP classification.

two=readtable([pwd,'/two_class.csv'],'Delimiter',',');
ten=readtable([pwd,'/ten_class.csv'],'Delimiter',',');

two=table2cell(two);
ten=table2cell(ten);

for i=1:1:size(two,1)
    for j=2:1:11
        ten{i,j}=ten{i,j}*two{i,2}; % Normalize the 10 scores from the extended module such that their sum is equivalent to the PVP score.
    end
end

result=[two,ten(:,2:12)];

result=cell2table(result,'VariableNames',{'Header',...
                                          'PVP_score',...
                                          'Predicted_result',...
                                          'Head_Tail_joining_score',...
                                          'Collar_score',...
                                          'Tail_sheath_score',...
                                          'Tail_fiber_score',...
                                          'Portal_score',...
                                          'Minor_tail_score',...
                                          'Major_tail_score',...
                                          'Baseplate_score',...
                                          'Minor_capsid_score',...
                                          'Major_capsid_score',...
                                          'Possible_class'});

if size(ResultFile,2)<4 || ~strcmp(ResultFile(end-3:end),'.csv')
    disp('Warning!! The name of the output file has been changed to:')
    disp([ResultFile,'.csv'])
    disp('Note: The current version of DeePVP uses "Comma-Separated Values (CSV)" as the format of the output file!!')
    ResultFile=[ResultFile,'.csv'];
end

writetable(result,ResultFile);
cmd=['rm -f ',pwd,'/two_class.csv'];
unix(cmd);
cmd=['rm -f ',pwd,'/ten_class.csv'];
unix(cmd);

disp(' ')
disp(' ')
disp(' ')

disp('DeePVP is Finished')

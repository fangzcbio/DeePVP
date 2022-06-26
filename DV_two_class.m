function DV_two_class(SeqFile,ResultFile,t,tmp)
% The subprograme called by "DeePVP_m.m" and "DeePVP_identification.m" for PVP identification.
t=str2num(t);

data=fastaread(SeqFile);

aa_onehot=zeros(20,2000*size(data,1),'int8');
for i=1:1:size(data,1)
    aa_onehot(:,(i-1)*2000+1:i*2000)=aa2onehot(data(i).Sequence,2000); % Convert the aa sequence to the one-hot matrix.
end
save([pwd,'/',tmp,'aa_onehot.mat'],'aa_onehot','-v7.3')
clear aa_onehot

cmd=['python ',pwd,'/predict.py ',pwd,'/model_2class/model.h5 ',pwd,'/',tmp];unix(cmd); % Make prediction based on the one-hot matrix.
delete([pwd,'/',tmp,'aa_onehot.mat']);

predict=dlmread([pwd,'/',tmp,'predict.csv']);
delete([pwd,'/',tmp,'predict.csv']);

for i=1:1:size(data,1)
    data(i,1).score=predict(i,1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate the final prediction based on the predicted scores.
for i=1:1:size(data,1)
    scores=data(i,1).score;
    if scores>=0.5
        data(i,1).prediction='PVP';
    else
        data(i,1).prediction='Non-PVP';
    end
end

            

for i=1:1:size(data,1)
    result{i,1}=data(i,1).Header;
    result{i,2}=data(i,1).score;
    result{i,3}=data(i,1).prediction;
end

result=cell2table(result,'VariableNames',{'Header','PVP_score','Predicted_result'});
writetable(result,ResultFile);

disp(' ')

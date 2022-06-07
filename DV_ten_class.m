function DV_ten_class(SeqFile,ResultFile,t,tmp)

t=str2num(t);

data=fastaread(SeqFile);

aa_onehot=zeros(20,2000*size(data,1),'int8');
for i=1:1:size(data,1)
    aa_onehot(:,(i-1)*2000+1:i*2000)=aa2onehot(data(i).Sequence,2000);
end
save([pwd,'/',tmp,'aa_onehot.mat'],'aa_onehot','-v7.3')
clear aa_onehot

cmd=['python ',pwd,'/predict.py ',pwd,'/model_10class/model.h5 ',pwd,'/',tmp];unix(cmd);
delete([pwd,'/',tmp,'aa_onehot.mat']);

predict=dlmread([pwd,'/',tmp,'predict.csv']);
delete([pwd,'/',tmp,'predict.csv']);

for i=1:1:size(data,1)
    data(i,1).score=predict(i,:);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for i=1:1:size(data,1)
    scores=data(i,1).score;
    [m,n]=max(scores);
    switch n
        case 1
            data(i,1).prediction='Head_Tail_joining	';
        case 2
            data(i,1).prediction='Collar';
        case 3
            data(i,1).prediction='Tail_sheath';
        case 4
            data(i,1).prediction='Tail_fiber';
        case 5
            data(i,1).prediction='Portal';
        case 6
            data(i,1).prediction='Minor_tail';
        case 7
            data(i,1).prediction='Major tail';
        case 8
            data(i,1).prediction='Baseplate';
        case 9
            data(i,1).prediction='Minor_capsid';
        case 10
            data(i,1).prediction='Major_capsid';
    end
end

            

for i=1:1:size(data,1)
    result{i,1}=data(i,1).Header;
    for j=2:1:11
        result{i,j}=data(i,1).score(j-1);
    end
    result{i,12}=data(i,1).prediction;
end

result=cell2table(result,'VariableNames',{'Header',...
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
writetable(result,ResultFile);

disp(' ')

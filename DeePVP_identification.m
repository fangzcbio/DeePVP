function DeePVP_identification

[file,path]=uigetfile('*','Select an input file for DeePVP main module');

SeqFile=[path,file];
ResultFile=[path,file,'.DeePVP_main.csv'];

t='0';
b='5000';
l=strfind(SeqFile,'/');
tmp=SeqFile;
for i=1:1:size(l,2)
    tmp(l(i))='_';
end
tmp1=['tmp1_t',t,'_b',b,'_',tmp,'/'];
%tmp2=['tmp2_t',t,'_b',b,'_',tmp,'/'];
clear tmp
b=str2num(b);

if exist([pwd,'/',tmp1],'dir')
    cmd=['rm -rf ',pwd,'/',tmp1];
    unix(cmd);
end
cmd=['mkdir ',pwd,'/',tmp1];
unix(cmd);

cmd=['cat ',SeqFile,' | grep ">" | wc -l >> ',pwd,'/',tmp1,'seqnum.txt'];
unix(cmd);
seqnum=importdata([pwd,'/',tmp1,'seqnum.txt']);
s=1;
c=1;
while s<=seqnum
    p=num2str(s);
    q=num2str(min(seqnum,s+b-1));
    cmd=["awk -v RS='>' 'NR>1{i++}i>=",p,'&&i<=',q,'{print ">"$0}',"' ",SeqFile,"|sed '/^$/d'>",pwd,'/',tmp1,'file',num2str(c),'.faa'];
    cmd2=[];
    for i=1:1:size(cmd,2)
        cmd2=strcat(cmd2,cmd(i));
    end
    unix(cmd2);
    %f=fastaread(SeqFile,'Blockread',[s,s+b-1]);
    %fastawrite([pwd,'/',tmp2,'file',num2str(c),'.fna'],f);
    %clear f
    DV_two_class([pwd,'/',tmp1,'file',num2str(c),'.faa'],[pwd,'/',tmp1,'out',num2str(c),'.csv'],t,tmp1);
    cmd=['rm ',pwd,'/',tmp1,'file',num2str(c),'.faa'];
    unix(cmd);
    disp(newline)
    disp(newline)
    disp(newline)
    disp(newline)
    disp(newline)
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp(['PVP identification: sequence ',num2str(s),' to ',num2str(min(seqnum,s+b-1)),' are finished!'])
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
    disp(newline)
    disp(newline)
    disp(newline)
    disp(newline)
    disp(newline)
    c=c+1;
    s=s+b;
end
disp('Organizing the results...')
c=c-1;
predict=[];
for i=1:1:c
    pre=readtable([pwd,'/',tmp1,'out',num2str(i),'.csv'],'Delimiter',',');
    pre=table2cell(pre);
    predict=[predict;pre];
end

cmd=['rm -rf ',pwd,'/',tmp1];
unix(cmd);

disp(newline)
disp(newline)
disp(newline)
disp(newline)
disp(newline)

if size(ResultFile,2)<4 || ~strcmp(ResultFile(end-3:end),'.csv')
    disp('Warning!! The name of the output file has been changed to:')
    disp([ResultFile,'.csv'])
    disp('Note: The current version of DeePVP uses "Comma-Separated Values (CSV)" as the format of the output file!!')
    ResultFile=[ResultFile,'.csv'];
end
result=predict;
result=cell2table(result,'VariableNames',{'Header','PVP_score','Predicted_result'});
writetable(result,ResultFile);
disp(' ')
disp('PVP identification is finished!')
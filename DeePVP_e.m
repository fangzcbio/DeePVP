function DeePVP_e(SeqFile,ResultFile,option1,num1,option2,num2)
% The subprograme called by the "DeePVP.m" for the PVP classification.
if nargin==2
    t='0';
    b='5000'; % batch size
elseif nargin==3
    error('Error: not enough input parameter')
elseif nargin==4
    if strcmp(option1,'-t')
        t=num1;
        b='5000';
    elseif strcmp(option1,'-b')
        t='0';
        b=num1;
    else
        error(['Error: no "',option1,'" option']);
    end
elseif nargin==5
    error('Error: not enough input parameter')
elseif nargin==6
    if strcmp(option1,'-t') && strcmp(option2,'-b')
        t=num1;
        b=num2;
    elseif strcmp(option1,'-b') && strcmp(option2,'-t')
        t=num2;
        b=num1;
    else
        error('Error: illegal option')
    end
end
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
    cmd=["awk -v RS='>' 'NR>1{i++}i>=",p,'&&i<=',q,'{print ">"$0}',"' ",SeqFile,"|sed '/^$/d'>",pwd,'/',tmp1,'file',num2str(c),'.faa']; % Separate the input file.
    cmd2=[];
    for i=1:1:size(cmd,2)
        cmd2=strcat(cmd2,cmd(i));
    end
    unix(cmd2);
    %f=fastaread(SeqFile,'Blockread',[s,s+b-1]);
    %fastawrite([pwd,'/',tmp2,'file',num2str(c),'.fna'],f);
    %clear f
    DV_ten_class([pwd,'/',tmp1,'file',num2str(c),'.faa'],[pwd,'/',tmp1,'out',num2str(c),'.csv'],t,tmp1); % PVP classification for each batch.
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
    disp(['PVP classification: sequence ',num2str(s),' to ',num2str(min(seqnum,s+b-1)),' are finished!'])
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
result=cell2table(result,'VariableNames',{'Header',...
                                          'Head_Tail_joining_score',...
                                          'Collar_score',...
                                          'Tail_sheath_score',...
                                          'Tail_fiber',...
                                          'Portal',...
                                          'Minor_tail',...
                                          'Major_tail',...
                                          'Baseplate',...
                                          'Minor_capsid',...
                                          'Major_capsid',...
                                          'Possible_class'});
writetable(result,ResultFile);
disp(' ')
disp('PVP classifiaction is Finished.')

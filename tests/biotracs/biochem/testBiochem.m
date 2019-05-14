%"""
%Unit tests for biotracs.biochem.*
%* License: BIOASTER License
%* Created: 2016
%Omics Hub, Bioinformatics team
%BIOASTER Technology Research Institute (http://www.bioaster.org)
%"""

function testBiochem()
    clc; close all force; fclose all; diary off;
    restoredefaultpath();
    
    addpath('../../');
    autoload( ...
        'PkgPaths', {fullfile(pwd, '../../../../')}, ...
        'Dependencies', {...
            'biotracs-m-biochem', ...
        }, ...
        'Variables',  struct(...
        ) ...
    );
    
    testDir = biotracs.core.env.Env.workingDir();
    testLogFile = fullfile(testDir, 'biotracs_biochem_tests.log.html');
    if exist(testLogFile,'file')
        delete(testLogFile);
    end
    
    if ~isfolder(testDir)
        mkdir(testDir);
    end
    diary(testLogFile);

    testDir = dir();
    n = length(testDir);
    for i = 1:n
        isTestDir = testDir(i).isdir && ...
            isempty(regexpi(testDir(i).name, '(\.)|(\.\.)|(testdata)|(*.(\.ignore)$)'));
        if isTestDir
            disp('*');
            fprintf('* Test biotracs.biochem %s\n', testDir(i).name);
            disp('*_________________________________________________');
            disp(' ')

            currentDir = ['./', testDir(i).name, '/'];
            d = dir( currentDir );
            for j=1:length(d)
                if ~d(j).isdir & regexpi( d(j).name, '^test(.+)(\.m)$', 'once' ) %#ok<AND2>
                    savedPwd = pwd;
                    cd( currentDir );
                    testFunc = d(j).name(1:end-2);
                    feval( testFunc, false );
                    cd(savedPwd);
                end
                close all force;
            end
        end
    end
    fprintf('Log location: ''%s''\n', testLogFile);
    diary off;
    fclose all;
    
    %HTML rendering
    text = fileread(testLogFile);
    text = regexprep(text,'(\r\n)|(\n)','<br/>');
    fid = fopen(testLogFile,'w');
    text = [...
        '<!DOCTYPE html>',...
        '<html>',...
        '<head>',...
        '<title>', biotracs.core.env.Env.appName(), ' - Test log</title>',...
        '</head>',...
        '<body style="font-family: ''Courier New'', Courier, monospace; font-size:12px;">',...  
        '<h1>BIOCODE - Test log</h1>',...
        '<div>Datetime: ',biotracs.core.date.Date.now(),'</div><br/>',...
        text,...
        '</body>',...
        '</html>',...
    ];
    fprintf(fid, '%s', text);
    fclose(fid);
    web(testLogFile, '-browser');
end
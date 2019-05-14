%"""
%Unit tests for biotracs.biochem.parser*
%* Date: 2019
%* Author:  D. A. Ouattara
%* License: BIOASTER License
%
%Omics Hub, Bioinformatics team
%BIOASTER Technology Research Institute (http://www.bioaster.org)
%"""

function testParser( cleanAll )
    if nargin == 0 || cleanAll
        clc; close all force;
        restoredefaultpath();
    end
    
    addpath('../../../');
    autoload( ...
        'PkgPaths', {fullfile(pwd, '../../../../../')}, ...
        'Dependencies', {...
            'biotracs-m-biochem', ...
        }, ...
        'Variables',  struct(...
        ) ...
    );

    %% Tests
    import matlab.unittest.TestSuite;
    Tests = TestSuite.fromFolder('./', 'IncludingSubfolders', true);
    Tests.run(); 
end
% BIOASTER
%> @file		ChemFastaParser.m
%> @class		biotracs.biochem.helper.ChemFastaParser
%        Parser for a chemfasta file (a fasta-like file but that contains formmula of chemical compounds (not peptides)
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		Sept. 2014

classdef ChemFastaParser < handle

    properties(SetAccess = protected)
        file;
        format = '';
        chemFastaStruct = {};
        
        %internal properties
        workingFile;
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        % Constructor
        function this = ChemFastaParser( iFile, iFormat )
            this.file = fullfile(iFile);
            if nargin >= 2
                this.format = iFormat;
            end
            this.prepareFile();
            this.chemFastaStruct = fastaread( this.workingFile );
        end
        
        function resource = parseChemFasta( this )
            resource = biotracs.core.mvc.model.ResourceSet(0, 'List of compounds');
            resource.setClassNameOfElements('biotracs.biochem.data.model.Compound');
            for i=1:length(this.chemFastaStruct)
                resource.add( biotracs.biochem.data.model.Compound( this.chemFastaStruct(i).Sequence ));
            end
        end
    end
    
    methods(Access = protected)
        
        function prepareFile( this )
            if strcmp(this.format, '')
                [~, ~, fileext] = fileparts(this.file);
                this.format = fileext(2:end);
            end
            if strcmpi(this.format, 'gz')
                sprintf('Uncompress file...\n');
                fileNames = biotracs.core.utils.uncompress( this.file, biotracs.core.env.Env.workingDir() );
                this.workingFile = fileNames{1};
            else
                this.workingFile = this.file;
            end
        end
    end
end

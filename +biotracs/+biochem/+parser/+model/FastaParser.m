% BIOASTER
%> @file		FastaParser.m
%> @class		biotracs.biochem.parser.model.FastaParser
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2014

classdef FastaParser < biotracs.core.parser.model.BaseParser
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = FastaParser()
            this@biotracs.core.parser.model.BaseParser();
        end
       
    end
    
    methods(Access = protected)
        
        function [ result ] = doParse( this, iFilePath )
            if ~isfile(iFilePath)
                error('The fasta file ''%s'' do not exist', iFilePath);
            end
            this.data = fastaread( iFilePath );
            result = biotracs.biochem.data.model.Fasta( this.data );
        end

    end
end

% BIOASTER
%> @file		SbmlParser.m
%> @class		biotracs.biochem.parser.model.SbmlParser
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef SbmlParser < biotracs.core.parser.model.BaseParser
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        % Constructor
        function this = SbmlParser( )
            %#function biotracs.biochem.parser.model.SbmlParserConfig
            
            this@biotracs.core.parser.model.BaseParser();
        end
    end
    
    methods(Access = protected)
        
        function [ result ] = doParse( this, iFilePath )
            disp( ['Parsing file ', iFilePath, ' ...'] );
            switch this.config.getParamValue('FileType')
                case 'sbml'
                    sbmlData = TranslateSBML( iFilePath, 0, 0 );
                    result = biotracs.biochem.data.model.Pathway( sbmlData );
                case 'biopax'
                    error('BioPAX parsing is not yet implemented');
                otherwise
                    error('Please, give file type');
            end

        end

    end
    
end

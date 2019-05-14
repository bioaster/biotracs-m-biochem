% BIOASTER
%> @file		Fasta.m
%> @class		biotracs.biochem.data.model.Fasta
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2015

classdef Fasta < biotracs.biochem.data.model.FastaInterface & biotracs.data.model.DataObject
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = Fasta( iData )
            if nargin == 0, iData = {}; end
            this@biotracs.biochem.data.model.FastaInterface();
            this@biotracs.data.model.DataObject( iData );            
        end
        
        %-- A --
        
        %-- C --
        
        %-- D --
        
        %-- E --

        function this = export( this, iFilePath )
            [dirPath,~, ext] = fileparts(iFilePath);
            switch lower(ext)
                case {'.mat'}
                    this.export@biotracs.data.model.DataObject(iFilePath);
                otherwise
                    if ~isfolder(dirPath) && ~mkdir(dirPath)
                        error('SPECTRA:Fasta:CouldNotCreateFileDir','Check write permissions in the directory %s', dirPath);
                    end
                    if isfile(iFilePath)
                        delete(iFilePath);
                    end
                    fastawrite( iFilePath, this.data );
            end      
        end
        
        %-- F --

        %-- G --
        
        function oHeader = getHeader( this, iIndex )
            oHeader = this.data(iIndex(1)).Header;
        end
        
        function oHeaders = getHeaders( this, iIndexes )
            if nargin == 1
                n = this.getLength();
            else
                n = length(iIndexes);
            end
            oHeaders = cell(1,n);
            for i=1:n
                oHeaders{i} = this.data(i).Header;
            end
        end
        
        function oSequence = getSequence( this, iIndex )
            oSequence = this.data(iIndex(1)).Sequence;
        end
        
        function oSequences = getSequences( this, iIndexes )
            if nargin == 1
                n = this.getLength();
            else
                n = length(iIndexes);
            end
            oSequences = cell(1,n);
            for i=1:n
                oSequences{i} = this.data(i).Sequence;
            end
        end
        
        function oIndexes = getIndexesByHeader( this, iSearchedLabelPattern )
            n = this.getLength();
            oIndexes = [];
            for i=1:n
               if ~isempty(regexpi(this.data(i).Header, iSearchedLabelPattern, 'once'))
                   oIndexes = [oIndexes, i];
               end
            end
        end
        
        function oData = getDataByHeader( this, iSearchedLabelPattern )
            indexes = this.getIndexesByHeader( iSearchedLabelPattern );
            oData = this.data(indexes);
        end
        
        function len = getLength( this )
            len = length(this.data);
        end
        
         
        %-- S --

        %-- T --
        
        function peptideSet = toPeptideSet( this )
            peptideSet = biotracs.core.mvc.model.ResourceSet();
			peptideSet.setRepository( this.repository );
            peptideSet.setClassNameOfElements('biotracs.biochem.data.model.Peptide');
			
			[ ~, filename, ~ ] = fileparts( this.repository );
			peptideSet.setLabel( filename );
			peptideSet.setDescription( ... 
				[ 'Parsed filePath:', this.repository ]...
			);
			
            for i=1:length(this.data)
                peptide = biotracs.biochem.data.model.Peptide( this.data(i).Sequence );
				peptide.setLabel( this.data(i).Sequence )...
						.setDescription( [ this.data(i).Header, '; ' , this.data(i).Sequence ] );
                peptideSet.add( peptide );
            end
        end
        
    end
    
    % -------------------------------------------------------
    % Implementation of abstract interfaces inherited 
    % from biotracs.core.ability.Queriable
    % -------------------------------------------------------
    
    methods(Access = public)

        % Selector for Fasta tranformation
        %> @param[in] Variables argument list
        % - cols        :[string] regular expression representing the names of the 
        %                   columns on which the query is applied
        % - match       : [any type] value to look for in the queried columns 
        % - filter_by_col_name : [string] regular expression representing the names of columns to retrieve in the final results
        % - filter_by_row_name :  not yet activated
        function oFasta = select( this, varargin )
            if nargin == 1
                oFasta = this;
                return;
            end
            
            p = inputParser();
            p.addParameter('Header', '.*', @ischar);
            p.addParameter('Sequence', biotracs.core.db.Predicate.ANY);
            
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            indexes = this.getIndexesByHeader( p.Results.Header );
            oFasta = biotracs.biochem.data.model.Fasta( this.data(indexes) );
        end
        
        function insert(~), end
        function remove(~), end
    end
    
    % -------------------------------------------------------
    % Static methods
    % -------------------------------------------------------
    
    methods(Static)
        
        function this = import( iFilePath, varargin )
            process = biotracs.biochem.parser.model.FastaParser();
            process.config.hydrateWith( varargin );
            process.setInputPortData( 'DataFile', biotracs.data.model.DataFile(iFilePath) );
            process.run();
            this = process.getOutputPortData('ResourceSet').getAt(1);            
        end
        
    end
    
end

% BIOASTER
%> @file		Peptide.m
%> @class		biotracs.biochem.data.model.Peptide
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2014

classdef Peptide < biotracs.biochem.data.model.Compound
    
    properties(SetAccess = protected)
        header = '';
        sequence = '';
    end
    
    events
    end
    
    methods
        % Constructor
        %> @param[in] iFormulaOrSequence [string, default = ''] Formula or Sequence of the Compound
        function this = Peptide( iSequence )
            this@biotracs.biochem.data.model.Compound();
            if nargin == 0, iSequence = ''; end
            this.setSequence( iSequence );
            
            %set property PreSet listener
            addlistener(this,...
                'formula',...
                'PreGet',...
                @biotracs.biochem.data.model.Peptide.handlePropGetEvent....
            ); 
        
%             %set property PreSet listener
%             addlistener(this,...
%                 'formula',...
%                 'PreSet',...
%                 @biotracs.biochem.data.model.Peptide.handlePropSetEvent....
%             ); 
        end
        
        
        %-- C --
        
        %-- G --
        
        function oHeader = getHeader( this )
            oHeader = this.header;
        end
        
        function oSequence = getSequence( this )
            oSequence = this.sequence;
            if strcmp(oSequence, '') 
                disp('Warning: The sequence cannot be constructed from the raw formula');
            end
        end
        
        %-- I --
        
        %-- S --
        
        % Lock setFormula
        function setFormula(~)
            error('Direct set of formula is not allowed. Please set peptide sequence instead.')
        end
        
        function this = setHeader( this, iHeader )
            if ~ischar(iHeader)
                error('Invalid sequence header; a string is required');
            end
            this.header = iHeader;
        end
        
        % Set peptide sequence
        % Warning: This setter does not check if the sequence is valid
        % To check that the sequence is valid 
        function this = setSequence( this, iSequenceAA )
            if ~ischar(iSequenceAA)
                error('Invalid sequence; a string is required');
            end
            this.sequence = iSequenceAA;
            this.doUpdateFormula();
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        %-- I --
        
        function doInitCompound( this, iSequence )
            if isempty( iSequence ), return; end
            if isnumeric(iSequence)
                this.doInitCompound@biotracs.biochem.data.model.Compound( iSequence );
            else
                this.setSequence( iSequence );
                this.formula = [];
            end
            this.setDescription( [ 'Peptide ', this.sequence, ' (Formula = ', this.label, ')' ] );
        end
        
        
        function doUpdateFormula( this )
            if ~isempty(this.formula), return; end
            atoms = biotracs.biochem.data.model.Peptide.validate( this.sequence );
            if ~isempty(atoms)
                this.formula = [ atoms.C atoms.H atoms.N atoms.O atoms.S ];
            else
                error('Invalid peptide sequence');
            end
        end
            
    end
    
    % -------------------------------------------------------
    % Static methods
    % -------------------------------------------------------
    
    methods(Static)
        
        % Validate a peptide sequence
        %> @param[i] iSequenceAA Peptide sequence
        %> @return The atomic composition corresponding to the peptide if it
        % is valid. If the sequence is not valid and empty array [] is
        % returned.
        function atoms = validate( iSequenceAA )
            try
				atoms = atomiccomp(iSequenceAA);
            catch
                atoms = [];
            end
        end
    
        function handlePropGetEvent( prop, evnt )
            %properties(evnt)
            %evnt.Source.DefiningClass
            switch prop.Name
                case 'formula'
                    evnt.AffectedObject.doUpdateFormula()
            end
        end
        
%         function handlePropSetEvent( prop, evnt )
%             %properties(evnt)
%             %evnt.Source.DefiningClass
%             switch prop.Name
%                 case 'formula'
%                     if ~strcmp(evnt.Source.DefiningClass, biotracs.biochem.data.model.Compound) &&...
%                        ~strcmp(evnt.Source.DefiningClass, biotracs.biochem.data.model.Peptide)
%                         error('Cannot set formula. Peptide sequence is required!');
%                     end
%             end
%         end
        
    end
    
end

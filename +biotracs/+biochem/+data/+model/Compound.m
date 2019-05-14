% BIOASTER
%> @file		Compound.m
%> @class		biotracs.biochem.data.model.Compound
%               Warning: Only biochemical compounds are supported !
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2014

classdef Compound < biotracs.core.mvc.model.Resource
    
    properties(Constant)
        ATOMS = {'C', 'H' ,'N', 'O', 'S'};
    end
    
    properties(SetAccess = protected, GetObservable)
        formula;                %[C H N O S]
    end

    methods
        % Constructor
        %> @param[in] iFormula [string, default = ''] Formula of the compound
        function this = Compound( iFormula )
            %call parent constructor
            if nargin == 0, iFormula = []; end
            this@biotracs.core.mvc.model.Resource();
            %continue with the other properties...
            this.doInitCompound( iFormula );
        end
        
        %-- C --
        
        %-- G --

        function oFomula = getFormula( this )
            oFomula = this.formula;
        end
        
        function oFomulaStr = getFormulaAsString( this )
            oFomulaStr = biotracs.biochem.Utilities.numericFormulaToStr( this.formula );
        end
        
        function [oIsotopicDist, oInfo] = getIsotopicDistribution( this, varargin )
            [ oIsotopicDist, oInfo ] = biotracs.biochem.helper.Utilities.isotopicDistribution(this.formula, varargin{:}, 'showplot', false);
        end

        %-- I --
        
        
        
        %-- S --
        
        function setFormula( this, iFormula )
            if isnumeric(iFormula)  %Eg. [ 1 3 ] <=> (C:1, H:3)
                this.formula = iFormula;
            elseif ischar(iFormula) % Eg. 'CH3'
                f = stoichtools.parse_formula(iFormula);
                atoms = biotracs.biochem.data.model.Compound.ATOMS;
                for i=1:length(atoms)
                    atom = atoms{i};
                    if isfield(f, atom)
                        this.formula = [ this.formula, f.(atom) ];
                    else
                        this.formula = [ this.formula, 0 ];
                    end
                end
            else
                error('Invalid formual, a numeric array [#C #H #N #O #S] is required');
            end
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        %-- I --
        
        % Initialize the compound
        %> @param iFormula Chemical formula of the compound [#C #H #N #O #S]
        %> @warning Only biochemical compounds are currently supported
        function doInitCompound( this, iFormula )
            if isempty( iFormula ), return; end
            
            this.setFormula( iFormula );
            if isnumeric(iFormula)
                this.setLabel( biotracs.biochem.helper.Utilities.numericFormulaToStr(iFormula) );
            elseif ischar(iFormula)
                this.setLabel( iFormula );
            end
            this.setDescription( [ this.label, ' compound' ] );
            
            %Mass spectrometry parameters
            %this.createParam('MinRetentionTime');
            %this.createParam('MaxRetentionTime');
        end
        
    end
    
    
    % -------------------------------------------------------
    % Static methods
    % -------------------------------------------------------
    
    methods(Static)
    end
    
end

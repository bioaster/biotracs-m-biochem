% BIOASTER
%> @file		Utilities.m
%> @class		biotracs.biochem.helper.Utilities
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2015

classdef Utilities
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods( Static )
        
        % Convert a numerical formular to string
        %> @param[in] iFormula : can be a numerical matrix [#C #H #N #O #S]
        % or a structure struct('C','#C', 'H','#H', ...), where
        % #C, #H, #N, #O, #S are the number of Carbone, Hydrogen, Nitrogen,
        % Oxygen, Sulfur, respectively
        %> @return The molecular formula as astring
        %
        % \use E.g. numericFormulaToStr( [6 13 1 2 0] ) will return
        % 'C6H13NO2'
        %
        function [ oStr ] = numericFormulaToStr( iFormula )
            oStr = '';
            if isstruct( iFormula )
                atom = fieldnames(iFormula);
                for i=1:length(f)
                    nbAtoms = iFormula.(atom);
                    oStr = [oStr, atom{i}, nbAtoms ];
                end
            elseif isnumeric( iFormula )
                for i=1:length(biotracs.biochem.data.model.Compound.ATOMS)
                    nbAtoms = iFormula(i);
                    oStr = [oStr, biotracs.biochem.data.model.Compound.ATOMS{i}, num2str(nbAtoms) ];
                end
            elseif ischar( iFormula )
                oStr = iFormula;
            end
        end
        
        % Compute the isotopic distribution from molecular formular
        % Wrap the native matlab function isotopicdist and provide more
        % functionalities such as computing the istopic distibution of the
        % [M+nH]+ and [M+nH]- adducts of a molecule M
        %
        %> @param[in] iNumericFormula: numerical matrix [#C #H #N #O #S]
        %> @param[in] varagin parameters: 
        %   - 'charge': number of charge (positive of negative) 
        %   - 'norm': true to normalize by the base peak; false otherwise
        %> @return The isotopic distribution (as a matrix) and its
        % information as a strucutre.
        %
        % \use E.g. 
        %   - isotopicDistribution( iNumericFormula, 'charge', +2, 'norm',
        %       true ) compute the normalized isotopic distribution of the [M+2H]+ molecular
        %       ion.
        %   - isotopicDistribution( iNumericFormula, 'charge', -1, 'norm',
        %       false ) compute the non-normalized isotopic distribution of the [M+H]- molecular
        %       ion.
        %
        function [ oIsotopicDist, oInfo ] = isotopicDistribution( iNumericFormula, varargin )
            p = inputParser;
            p.addParameter('charge',0,@isnumeric);
            p.addParameter('norm',true,@islogical);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            if( p.Results.charge ~= 0 )
                ionFormula = iNumericFormula;
                ionFormula(2) = ionFormula(2) + p.Results.charge;
                [ oIsotopicDist, oInfo ] = isotopicdist(ionFormula, 'showplot', false);
                
                %shift isotopiic distrubution by the mass of the total number of electron
                oIsotopicDist(:,1) = ( oIsotopicDist(:,1) - p.Results.charge * biotracs.biochem.constants.Mass.electron );
                %scale the spectrum by the number of charge (if m/z)
                oIsotopicDist(:,1) = oIsotopicDist(:,1)/p.Results.charge;
                
                oInfo.formula = iNumericFormula;
                oInfo.ionFormula = ionFormula;
                oInfo.charge = p.Results.charge;
            else
                [ oIsotopicDist, oInfo ] = isotopicdist(iNumericFormula, 'showplot', false);
                oInfo.formula = iNumericFormula;
                oInfo.ionFormula = iNumericFormula;
                oInfo.charge = 0;
            end
            
            % normalize distribution
            if p.Results.norm
                index = oIsotopicDist(:,2) == max(oIsotopicDist(:,2));
                abundance = oIsotopicDist(index, 2);
                oIsotopicDist(:,2) = 100 * oIsotopicDist(:,2) ./ abundance;
            end
        end
        
    end
end

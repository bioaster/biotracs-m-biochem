% BIOASTER
%> @file		Pathway.m
%> @class		biotracs.biochem.data.model.Pathway
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		

classdef Pathway < biotracs.core.mvc.model.ResourceSet
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
        organism;
        strain;
        model;          %LibSBML model
    end

    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = Pathway( iModel )
            this@biotracs.core.mvc.model.ResourceSet();
            if nargin == 1
                this.model = iModel;
            end
        end

        %-- G --
        
        function [ model ] = getModel( this )
            model = this.model;
        end
        
        % Get the total number of species in the model 
        %> @return Number of species
        function numberOfSpecies = getNumberOfSpecies( this )
            numberOfSpecies = length(this.model.species);
        end
        
        % Get the total number of reactions in the model 
        %> @return Number of reactions
        function numberOfSpecies = getNumberOfReactions( this )
            numberOfSpecies = length(this.model.reaction);
        end
        
        % Get the list of reactions ids
        %> @return listOfReactionsIds [cell of string] List of reactions ids
        function listOfReactionsIds = getListOfReactionsIds( this )
            nbReactions = this.getNumberOfReactions();
            listOfReactionsIds = cell(1, nbReactions);
            for i=1:nbReactions
                listOfReactionsIds{i} = this.model.reaction(i).id;
            end
        end
        
        % Get the list of reactions names
        %> @return listOfReactionsNames [cell of string] List of reactions names
        function listOfReactionsNames = getListOfReactionsNames( this )
            nbReactions = this.getNumberOfReactions();
            listOfReactionsNames = cell(1, nbReactions);
            for i=1:nbReactions
                if isempty(this.model.reaction(i).name)
                    listOfReactionsNames{i} = '';
                else
                    listOfReactionsNames{i} = this.model.reaction(i).name;
                end
            end
        end
        
        % Get the list of species ids
        %> @return listOfSpeciesIds [cell of string] List of species ids
        function listOfSpeciesIds = getListOfSpeciesIds( this )
            nbSpecies = this.getNumberOfSpecies();
            listOfSpeciesIds = cell(1, nbSpecies);
            for i=1:nbSpecies
                listOfSpeciesIds{i} = this.model.species(i).id;
            end
        end
        
        % Get the list of species names
        %> @return listOfSpeciesNames [cell of string] List of species names
        function listOfSpeciesNames = getListOfSpeciesNames( this )
            nbSpecies = this.getNumberOfSpecies();
            listOfSpeciesNames = cell(1, nbSpecies);
            for i=1:nbSpecies
                listOfSpeciesNames{i} = this.model.species(i).name;
            end
        end
        
        % Generate the stoichiometric matrix of the model
        %> @return stoichMatrix The stoichiometric matrix
        function stoichMatrix = generateStoichiometricMatrix( this )
            nbSpecies = this.getNumberOfSpecies();
            nbReactions = this.getNumberOfReactions();
            [listOfSpeciesIds, listOfSpeciesNames] = this.getSortedListOfSpecies();
            stoichMatrix.rowNames = listOfSpeciesNames;
            stoichMatrix.columnNames = this.getListOfReactionsIds();
            stoichMatrix.data = zeros( nbSpecies, nbReactions );
            stoichMatrix.reversible = zeros( 1, nbReactions );
               
            %ToDo : code refactoring
            for reactionIndex = 1:nbReactions
                reaction = this.model.reaction( reactionIndex );
                stoichMatrix.reversible(reactionIndex) = reaction.reversible;
                    
                %.. each reactant of the reaction
                for i = 1:length(reaction.reactant)
                    speciesId = reaction.reactant(i).species;
                    stoichValue = reaction.reactant(i).stoichiometry;
                    speciesIndex = biotracs.core.utils.cellfind( listOfSpeciesIds, speciesId );
                    stoichMatrix.data( speciesIndex, reactionIndex ) = -stoichValue;
                end
                
                %.. each product of the reaction
                for i = 1:length(reaction.product)
                    speciesId = reaction.product(i).species;
                    stoichValue = reaction.product(i).stoichiometry;
                    speciesIndex = biotracs.core.utils.cellfind( listOfSpeciesIds, speciesId );
                    stoichMatrix.data( speciesIndex, reactionIndex ) = stoichValue;
                end
            end   
            stoichMatrix = biotracs.biochem.data.model.Pathway.removeInvariantSpeciesFromStoichMatrix(stoichMatrix);
        end
        
        function stoichTable = generateStoichiometricMatrixAsTable( this )
            stoichMatrix = this.generateStoichiometricMatrix();
            stoichMatrix.rowNames{end+1} = 'Reversible';
            stoichTable = array2table(...
                [stoichMatrix.data; stoichMatrix.reversible],...
                'VariableNames',stoichMatrix.columnNames,...
                'RowNames',stoichMatrix.rowNames...
            );
        end
        
        %-- S --
        
        % Set pathway model
        %> @param[in] iModel [-mat ressource] %LibSBML tree parsed from an SBML file
        function this = setModel( this, iModel )
            this.model = iModel;
        end
        
        % Get the list of species as (ids, names) after sorting ids in ascendent order
        %> @return sortedListOfIds [cell of string] List of species ids
        %> @return sortedListOfIds [cell of string] List of species names
        function [sortedListOfIds, sortedListOfNames] = getSortedListOfSpecies( this )
            unsortedListOfIds = this.getListOfSpeciesIds();
            unsortedListOfNames = this.getListOfSpeciesNames();
            sortedListOfIds = sort(unsortedListOfIds);
            sortedListOfNames = cell(1, length(unsortedListOfNames));
            for i=1:length(sortedListOfIds)
                j = biotracs.core.utils.cellfind( unsortedListOfIds, sortedListOfIds{i} );
                sortedListOfNames{i} = unsortedListOfNames{j};
            end
        end

        % Set organism
        %> @param[in] iOrganism Name of the organism
        function this = setOrganism( this, iOrganism )
            this.organism = iOrganism;
        end
        
        % Set strain
        %> @param[in] iStrain Name of the strain
        function this = setStrain( this, iStrain )
            this.strain = iStrain;
        end
        
    end
    
    methods(Access = protected)
        
        function doCopy( this, iPathway, varargin )
            this.doCopy@biotracs.core.mvc.model.ResourceSet(iPathway, varargin{:});
            this.organism = iPathway.organism;
            this.strain = iPathway.strain;
            this.model = iPathway.model;
        end
        
    end
    
    % -------------------------------------------------------
    % Private methods
    % -------------------------------------------------------
    
    methods(Static)
        
        % Remove form the stoichiometrix matrix all invariant (non-connected) species
        %> @return stoichMatrix The stoichiometric matrix after filtering
        function stoichMatrix = removeInvariantSpeciesFromStoichMatrix( stoichMatrix )
            sumOfRows = sum(abs(stoichMatrix.data), 2);
            nullRowIndexes = find(sumOfRows == 0);
            stoichMatrix.data(nullRowIndexes, :) = [];
            stoichMatrix.rowNames(nullRowIndexes) = [];
        end
        
        % Import a pathway from a file (e.g. sbml file)
        %> @return The pathway
        function this = import(iFilePath, varargin)
            process = biotracs.biochem.parser.model.SbmlParser();
            process.getConfig().hydrateWith( varargin );
            process.setInputPortData( 'DataFile', biotracs.data.model.DataFile(iFilePath) );
            process.run();
            this = process.getOutputPortData('ResourceSet').getAt(1);
        end
    end
    
    
end

% BIOASTER
%> @file		FastaInterface.m
%> @class		biotracs.data.model.FastaInterface
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2015

classdef (Abstract) FastaInterface < biotracs.core.ability.Queriable & biotracs.data.model.DataObjectInterface
    
    properties(SetAccess = protected)
        tags = {};
    end
    
    properties(Dependent = true)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = FastaInterface( )
            this@biotracs.core.ability.Queriable();
            this@biotracs.data.model.DataObjectInterface();
        end
        
    end
    
    % -------------------------------------------------------
    % Abstract interfaces
    % -------------------------------------------------------
    
    methods( Abstract )

    end

end

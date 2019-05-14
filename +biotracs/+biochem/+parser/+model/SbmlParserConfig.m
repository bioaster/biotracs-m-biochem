% BIOASTER
%> @file		SbmlParserConfig.m
%> @class		biotracs.biochem.parser.model.SbmlParserConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016


classdef SbmlParserConfig < biotracs.core.parser.model.BaseParserConfig
	 
	 properties(Constant)
	 end
	 
	 properties(SetAccess = protected)
	 end

	 % -------------------------------------------------------
	 % Public methods
	 % -------------------------------------------------------
	 
	 methods
		  
		  % Constructor
		  function this = SbmlParserConfig()
				this@biotracs.core.parser.model.BaseParserConfig();
				this.setDescription('Configuration parameters of the SBML parser');
                this.updateParamValue('FileExtensionFilter', '.xml,.sbml');
                this.createParam('FileType', 'sbml', 'Constraint', biotracs.core.constraint.IsInSet({'sbml'}));
		  end
		  
		  
	 end
	 
	 % -------------------------------------------------------
	 % Protected methods
	 % -------------------------------------------------------
	 
	 methods(Access = protected)
	 end

end

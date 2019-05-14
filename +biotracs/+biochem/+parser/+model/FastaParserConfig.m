% BIOASTER
%> @file		FastaParserConfig.m
%> @class		biotracs.biochem.parser.model.FastaParserConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016


classdef FastaParserConfig < biotracs.core.parser.model.BaseParserConfig
	 
	 properties(Constant)
	 end
	 
	 properties(SetAccess = protected)
	 end

	 % -------------------------------------------------------
	 % Public methods
	 % -------------------------------------------------------
	 
	 methods
		  
		  % Constructor
		  function this = FastaParserConfig()
				this@biotracs.core.parser.model.BaseParserConfig();
				this.setDescription('Configuration parameters of the FASTA parser');                
                this.updateParamValue('FileExtensionFilter', '.fasta,.fa');
		  end
		  
		  
	 end
	 
	 % -------------------------------------------------------
	 % Protected methods
	 % -------------------------------------------------------
	 
	 methods(Access = protected)
	 end

end

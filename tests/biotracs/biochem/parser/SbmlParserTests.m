classdef SbmlParserTests < matlab.unittest.TestCase

    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir, '/biochem/parser/SbmlParserTests');
    end
    
    methods (Test)
        
        function testParseToyPathway_1(testCase)
            file = strcat(pwd,'/../testdata/sbml/ToyPathway-1.xml');
            process = biotracs.biochem.parser.model.SbmlParser();
            c = process.getConfig();
            c.updateParamValue('WorkingDirectory',testCase.workingDir);
            process.setLabel('1-SbmlParsingProcess');
            process.setInputPortData('DataFile', biotracs.data.model.DataFile(file));
            process.run();
            pathway = process.getOutputPortData('ResourceSet').getAt(1);
            testCase.verifyEqual( class(pathway), 'biotracs.biochem.data.model.Pathway' );
            testCase.verifyEqual( length(pathway.getModel().species), 6 );
            testCase.verifyEqual( length(pathway.getModel().reaction), 2 );
        end
        
        function testParseToyPathway_2(testCase)
            file = strcat(pwd,'/../testdata/sbml/ToyPathway-2.xml');
            process = biotracs.biochem.parser.model.SbmlParser();
            c = process.getConfig();
            c.updateParamValue('WorkingDirectory',testCase.workingDir);
            process.setLabel('2-SbmlParsingProcess');
            process.setInputPortData('DataFile', biotracs.data.model.DataFile(file));
            process.run();
            r = process.getOutputPortData('ResourceSet');
            r.summary
            pathway = r.getAt(1);            
            pathway.setOrganism('Escherichia coli');
            pathway.setStrain('BL21');
            testCase.verifyEqual( length(pathway.getModel().species), 8 );
            testCase.verifyEqual( length(pathway.getModel().reaction), 2 );
            testCase.verifyEqual( pathway.organism, 'Escherichia coli' );
            testCase.verifyEqual( pathway.strain, 'BL21' );
        end
        
        function testParseBothPathways(testCase)
            file = strcat(pwd,'/../testdata/sbml/');
            process = biotracs.biochem.parser.model.SbmlParser();
            c = process.getConfig();
            c.updateParamValue('WorkingDirectory',testCase.workingDir);
            process.setInputPortData('DataFile', biotracs.data.model.DataFile(file));
            process.run();
            pathway1 = process.getOutputPortData('ResourceSet').getAt(1);
            pathway2 = process.getOutputPortData('ResourceSet').getAt(2);
            testCase.verifyEqual( length(pathway2.getModel().species), 8 );
            testCase.verifyEqual( length(pathway1.getModel().species), 6 );
        end
        
    end
    
end

classdef PathwayTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)
        function testDefaultConstructor(testCase)
            pathway = biotracs.biochem.data.model.Pathway();
            testCase.verifyClass(pathway, 'biotracs.biochem.data.model.Pathway');
            testCase.verifyEqual(pathway.description, '');
            testCase.verifyEqual(pathway.getClassName(), 'biotracs.biochem.data.model.Pathway');
        end

        function testSetModel(testCase)
            pathway = biotracs.biochem.data.model.Pathway();
            sbmlTree = load('../../testdata/pathway/sbmlTree_TP1.mat');
            pathway.setModel(sbmlTree.model);
            testCase.verifyEqual(pathway.model, sbmlTree.model);
            testCase.verifyEqual(pathway.getNumberOfSpecies(), 6);
            testCase.verifyEqual(pathway.getNumberOfReactions(), 2);
            
            listOfReactionsIds = pathway.getListOfReactionsIds();
            testCase.verifyEqual( listOfReactionsIds, {'re1','re2'} );
            
            listOfReactionsNames = pathway.getListOfReactionsNames();
            testCase.verifyEqual( listOfReactionsNames, {'degradation of M1/synthesis of M2',''} );
            
            listOfSpeciesNames = pathway.getListOfSpeciesNames();
            testCase.verifyEqual( listOfSpeciesNames, {'M1','M2','M3','ATP','ADP','E1'} );
            
            listOfSpeciesIds = pathway.getListOfSpeciesIds();
            testCase.verifyEqual( listOfSpeciesIds, {'s1','s2','s5','s3','s4','s6'} );
            
            
            [ids, names] = pathway.getSortedListOfSpecies();
            testCase.verifyEqual( ids, {'s1','s2','s3','s4','s5','s6'} );
            testCase.verifyEqual( names, {'M1','M2','ATP','ADP','M3','E1'} );
        end

        function testStoichMatrix(testCase)
            pathway = biotracs.biochem.data.model.Pathway();
            sbmlTree = load('../../testdata/pathway/sbmlTree_TP1.mat');
            pathway.setModel(sbmlTree.model);
            expectedStoichMatrix.data = [
                -1  0
                +1  -1
                -1  -1
                +1  +1
                0   +1
            ];
            expectedStoichMatrix.columnNames = {'re1','re2'};
            expectedStoichMatrix.rowNames = {'M1','M2','ATP','ADP','M3'};
            expectedStoichMatrix.reversible = [0, 0];
            stoichMatrix = pathway.generateStoichiometricMatrix();
            testCase.verifyEqual(stoichMatrix, expectedStoichMatrix);
        end
        
        function testSbmlTreeTP2(testCase)
            pathway = biotracs.biochem.data.model.Pathway();
            sbmlTree = load('../../testdata/pathway/sbmlTree_TP2.mat');
            pathway.setModel(sbmlTree.model);
            expectedStoichMatrix.data = [
                -1  0
                +1  0
                -1  -1
                +1  +1
                0   +1
                0  -2
            ];
            expectedStoichMatrix.columnNames = {'re1','re2'};
            expectedStoichMatrix.rowNames = {'M1','M2','ATP','ADP','M3','M4',};
            expectedStoichMatrix.reversible = [0, 1];
            stoichMatrix = pathway.generateStoichiometricMatrix();
            testCase.verifyEqual(stoichMatrix, expectedStoichMatrix);
        end
        
        function testImport(testCase)
            file = fullfile('../../testdata/sbml/ToyPathway-2.xml');
            pathway = biotracs.biochem.data.model.Pathway.import(...
                file, ...
                'FileType', 'sbml', ...
                'WorkingDirectory', biotracs.core.env.Env.workingDir()...
                );
            expectedStoichMatrix.data = [
                -1  0
                +1  0
                -1  -1
                +1  +1
                0   +1
                0  -2
            ];
            expectedStoichMatrix.columnNames = {'re1','re2'};
            expectedStoichMatrix.rowNames = {'M1','M2','ATP','ADP','M3','M4'};
            expectedStoichMatrix.reversible = [0, 1];
            stoichMatrix = pathway.generateStoichiometricMatrix();
            testCase.verifyEqual(stoichMatrix, expectedStoichMatrix);
            testCase.verifyEqual(pathway.repository, file);
        end

    end
    
end

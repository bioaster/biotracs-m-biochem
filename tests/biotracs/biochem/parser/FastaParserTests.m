classdef FastaParserTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    methods (Test)
        
        function testParser(testCase)
            file = '../testdata/toy_fasta.fa';
            process = biotracs.biochem.parser.model.FastaParser();
            process.setInputPortData( 'DataFile', biotracs.data.model.DataFile(file) );
            process.run();
            
            fasta = process.getOutputPortData('ResourceSet').getAt(1);      
            listOfPepetides = fasta.toPeptideSet();
            testCase.verifyEqual( listOfPepetides.getLength(), 37 );
            testCase.verifyEqual( listOfPepetides.getAt(1).getSequence(), 'NEKGEVSEKIITRADGTRL' );
            testCase.verifyEqual( listOfPepetides.getAt(18).getSequence(), 'IATVDKL' );
        end
        
        function testParseFolder(testCase)
            file = '../testdata/';
            process = biotracs.biochem.parser.model.FastaParser();
            process.getConfig().updateParamValue('Recursive', true);
            process.setInputPortData( 'DataFile', biotracs.data.model.DataFile(file) );
            process.run();
            
            fasta = process.getOutputPortData('ResourceSet').get('toy_fasta.fa');      
            listOfPepetides = fasta.toPeptideSet();
            testCase.verifyEqual( listOfPepetides.getLength(), 37 );
            testCase.verifyEqual( listOfPepetides.getAt(1).getSequence(), 'NEKGEVSEKIITRADGTRL' );
            testCase.verifyEqual( listOfPepetides.getAt(18).getSequence(), 'IATVDKL' );
            
            fasta = process.getOutputPortData('ResourceSet').get('toy_fasta2.fasta');      
            listOfPepetides = fasta.toPeptideSet();
            testCase.verifyEqual( listOfPepetides.getLength(), 29 );
            testCase.verifyEqual( listOfPepetides.getAt(18).getSequence(), 'IATVDKL' );
        end
        
    end
    
end

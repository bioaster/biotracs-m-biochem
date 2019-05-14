classdef FastaTests < matlab.unittest.TestCase
    
    properties (TestParameter)
        %workingDir = [ biotracs.core.env.Env.workingDir, '/FastaTests/' ]
    end
    
    methods (Test)
        
        function testFastaData(testCase)
            fasta = biotracs.biochem.data.model.Fasta.import( strcat(pwd,'/../../testdata/toy_fasta.fa') );
            data = fasta.getData();
            
            testCase.verifyEqual( length(data), 37 );
            testCase.verifyEqual( fasta.getLength(), 37 );
        end
        
        function testSelector(testCase)
            fasta = biotracs.biochem.data.model.Fasta.import( strcat(pwd,'/../../testdata/toy_fasta.fa') );
            
            %Get header indexes
            indexes = fasta.getIndexesByHeader('OS=Escherichia.*');
            testCase.verifyEqual( indexes, [36, 37] );
            
            indexes = fasta.getIndexesByHeader('PE=3');
            testCase.verifyEqual( indexes, [32    33    34    35    36] );
            
            %Get data by header
            data = fasta.getDataByHeader('OS=Escherichia.*');
            testCase.verifyEqual( length(data), 2 );
            testCase.verifyEqual( data(1).Header, 'sp|P77569|MHPR_ECOLI Mhp operon transcriptional activator OS=Escherichia coli (strain K12) GN=mhpR PE=3 SV=2' );            
            testCase.verifyEqual( data(2).Header, 'sp|P77589|MHPT_ECOLI 3-(3-hydroxy-phenyl)propionate transporter OS=Escherichia coli (strain K12) GN=mhpT PE=1 SV=2' );
            
            
            ecoliFasta = fasta.select('header', 'OS=Escherichia.*');
            testCase.verifyEqual( ecoliFasta.getLength(), 2 );
            
            testCase.verifyEqual( ecoliFasta.getHeaders(1), {'sp|P77569|MHPR_ECOLI Mhp operon transcriptional activator OS=Escherichia coli (strain K12) GN=mhpR PE=3 SV=2'} );
            testCase.verifyEqual( ecoliFasta.getHeaders(1:2), ...
                {'sp|P77569|MHPR_ECOLI Mhp operon transcriptional activator OS=Escherichia coli (strain K12) GN=mhpR PE=3 SV=2',...
                'sp|P77589|MHPT_ECOLI 3-(3-hydroxy-phenyl)propionate transporter OS=Escherichia coli (strain K12) GN=mhpT PE=1 SV=2'} );
            
        end
        
    end
    
end

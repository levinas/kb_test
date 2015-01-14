use strict;
use warnings;

use Data::Dumper;

use Bio::KBase::KBaseTrees::Client;
use Bio::KBase::userandjobstate::Client;

# note: we need to make sure the tree server is configured to use the same WS and UJS endpoints
my $treeURL = "https://kbase.us/services/trees";
my $ujsURL  = "https://kbase.us/services/userandjobstate"; 


# config settings
# my $userId   = "wstester4";
# my $password = "****";
my $test_workspace = "jenkins-method-tests";  # the workspace to place the output
my $featureset_ref = "jenkins-method-tests/TestFeatureSet";

# create the clients
# my $tr = Bio::KBase::KBaseTrees::Client->new($treeURL, user_id=>$userId, password=>$password);
# my $ujs = Bio::KBase::userandjobstate::Client->new($ujsURL, user_id=>$userId, password=>$password);
my $tr = Bio::KBase::KBaseTrees::Client->new($treeURL);
my $ujs = Bio::KBase::userandjobstate::Client->new($ujsURL);

#    /* Input data type for construct_multiple_alignment method. Method produces object of MSA type.
#		
#        gene_sequences - (optional) the mapping from gene ids to their sequences; either gene_sequences
#            or featureset_ref should be defined.
#		featureset_ref - (optional) reference to FeatureSet object; either gene_sequences or
#            featureset_ref should be defined.
#        alignment_method - (optional) alignment program, one of: Muscle, Clustal, ProbCons, T-Coffee, 
#        	Mafft (default is Clustal).
#        is_protein_mode - (optional) 1 in case sequences are amino acids, 0 in case of nucleotides 
#        	(default value is 1).
#        out_workspace - (required) the workspace to deposit the completed alignment
#        out_msa_id - (optional) the name of the newly constructed msa (will be random if not present 
#        	or null)
#    */
#    typedef structure {
#        mapping<string, string> gene_sequences;
#        ws_featureset_id featureset_ref; 
#        string alignment_method;
#        int is_protein_mode;
#        string out_workspace;
#        string out_msa_id;
#    } ConstructMultipleAlignmentParams;
#
#    funcdef construct_multiple_alignment(ConstructMultipleAlignmentParams params) returns (job_id) authentication required;


my $params = {
    featureset_ref => $featureset_ref,
    out_msa_id => 'test.gene.msa.out',
    out_workspace => $test_workspace,
    is_protein_mode => 1,
    alignment_method => 'Muscle' # one of  Muscle, Clustal, ProbCons, T-Coffee, Mafft
};
print Dumper($params);
my $job_id = $tr->construct_multiple_alignment($params);


my ($info, $complete, $error);
print 'my $job_id="'.$job_id."\";\n";
while (!$complete && !$error) {
    $info = $ujs->get_job_info($job_id);
    $complete = $info->[10];
    $error = $info->[11];
    print "--- ".$info->[2]." - ".$info->[4]." - complete? $complete - error? $error\n";
    sleep(5) if(!$complete && !$error); 
}
print "\njob result:\n";
print Dumper($info);


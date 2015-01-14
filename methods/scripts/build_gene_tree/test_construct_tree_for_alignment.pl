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
my $msa_ref = "jenkins-method-tests/test.gene.msa";

# create the clients
# my $tr = Bio::KBase::KBaseTrees::Client->new($treeURL, user_id=>$userId, password=>$password);
# my $ujs = Bio::KBase::userandjobstate::Client->new($ujsURL, user_id=>$userId, password=>$password);
my $tr = Bio::KBase::KBaseTrees::Client->new($treeURL);
my $ujs = Bio::KBase::userandjobstate::Client->new($ujsURL);


#	/* Input data type for construct_tree_for_alignment method. Method produces object of Tree type.
#		
#		msa_ref - (required) reference to MSA input object.
#        tree_method - (optional) tree construction program, one of 'Clustal' (Neighbor-joining approach) or 
#        	'FastTree' (where Maximum likelihood is used), (default is 'Clustal').
#        min_nongap_percentage_for_trim - (optional) minimum percentage of non-gapped positions in alignment column,
#        	if you define this parameter in 50, then columns having less than half non-gapped letters are trimmed
#        	(default value is 0 - it means no trimming at all). 
#        out_workspace - (required) the workspace to deposit the completed tree
#        out_tree_id - (optional) the name of the newly constructed tree (will be random if not present or null)
#	*/
#	typedef structure {
#		ws_alignment_id msa_ref;
#		string tree_method;
#		int min_nongap_percentage_for_trim;
#        string out_workspace;
#        string out_tree_id;
#	} ConstructTreeForAlignmentParams;
#
#	funcdef construct_tree_for_alignment(ConstructTreeForAlignmentParams params) returns (job_id) authentication required; 


my $params = {
    msa_ref => $msa_ref,
    out_tree_id => 'test.gene.tree',
    out_workspace => $test_workspace,
    tree_method => 'FastTree' # one of  Clustal, FastTree
};
print Dumper($params);
my $job_id = $tr->construct_tree_for_alignment($params);


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






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
my $test_genome_ref = "KBasePublicGenomesV4/kb|g.483"; # the genome to use; for now we use a public genome in the production WS

# create the clients
# my $tr = Bio::KBase::KBaseTrees::Client->new($treeURL, user_id=>$userId, password=>$password);
# my $ujs = Bio::KBase::userandjobstate::Client->new($ujsURL, user_id=>$userId, password=>$password);
my $tr = Bio::KBase::KBaseTrees::Client->new($treeURL);
my $ujs = Bio::KBase::userandjobstate::Client->new($ujsURL);


#    typedef structure {
#        list<genome_ref> new_genomes;
#        ws_genomeset_id genomeset_ref;
#        string out_workspace;
#        string out_tree_id;
#        int use_ribosomal_s9_only;
#        int nearest_genome_count;
#    } ConstructSpeciesTreeParams;
#
#    funcdef construct_species_tree(ConstructSpeciesTreeParams input) returns (job_id) authentication required;

my $params = {
    new_genomes => [$test_genome_ref],
    out_tree_id => 'test.tree.out',
    out_workspace => $test_workspace,
    use_ribosomal_s9_only => 1,
    nearest_genome_count => 5
};
print Dumper($params);
my $job_id = $tr->construct_species_tree($params);


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

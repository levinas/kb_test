use strict;
use warnings;

use Data::Dumper;

use GenomeComparisonClient;
use Bio::KBase::userandjobstate::Client;

# note: we need to make sure the tree server is configured to use the same WS and UJS endpoints
my $srvURL = "https://kbase.us/services/genome_comparison";
my $ujsURL  = "https://kbase.us/services/userandjobstate"; 


# config settings
# my $userId   = "kbasetest";
# my $password = "****";
my $test_workspace = "jenkins-method-tests";  # the workspace to place the output
my $test_output_id = "test.protcmp.out";
# for now we use a public genome in the production WS
my $input_workspace = "KBasePublicGenomesV4";
my $test_genome1 = "kb|g.1312"; 
my $test_genome2 = "kb|g.1313"; 

# create the clients
# Perl client could be downloaded from here: 
#     https://github.com/kbase/genome_comparison/blob/master/clients/GenomeComparisonClient.pm
# my $srv = Bio::KBase::GenomeComparison::GenomeComparison->new($srvURL, user_id=>$userId, password=>$password);
# my $ujs = Bio::KBase::userandjobstate::Client->new($ujsURL, user_id=>$userId, password=>$password);
my $srv = GenomeComparisonClient->new($srvURL);
my $ujs = Bio::KBase::userandjobstate::Client->new($ujsURL);


my $params = {
    genome1ws => $input_workspace,
    genome1id => $test_genome1,
    genome2ws => $input_workspace,
    genome2id => $test_genome2,
    out_tree_id => $test_output_id,
    out_workspace => $test_workspace,
    sub_bbh_percent => 90,
    max_evalue => "1e-10"
};
print Dumper($params);
my $job_id = $srv->blast_proteomes($params);


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

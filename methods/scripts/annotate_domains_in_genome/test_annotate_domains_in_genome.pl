use strict;
use warnings;

use Data::Dumper;

use Bio::KBase::KBaseGeneFamilies::Client;
use Bio::KBase::userandjobstate::Client;

# note: we need to make sure the gene_families server is configured to use the same WS and UJS endpoints
my $srvURL = "https://kbase.us/services/gene_families";
my $ujsURL  = "https://kbase.us/services/userandjobstate"; 

# config settings
my $userId   = "kbasetest";
my $password = "****";
my $test_workspace = "jenkins-method-tests";  # the workspace to place the output
my $test_output_id = "test.genefamilies.out";
# for now we use a public genome in the production WS
my $genome_workspace = "KBasePublicGenomesV4";
my $test_genome = "kb|g.0"; 
my $domains_workspace = "KBasePublicGeneDomains";
my $test_model_set = "SMART-only"; 

# create the clients
# Perl client could be downloaded from here: 
#     https://github.com/kbase/gene_families/blob/master/lib/Bio/KBase/KBaseGeneFamilies/Client.pm
my $srv = Bio::KBase::KBaseGeneFamilies::Client->new($srvURL, user_id=>$userId, password=>$password);
my $ujs = Bio::KBase::userandjobstate::Client->new($ujsURL, user_id=>$userId, password=>$password);

my $params = {
    genome => "$genome_workspace/$test_genome",
    dms_ref => "$domains_workspace/$test_model_set",
    out_workspace => $test_workspace,
    out_result_id => $test_output_id
};
print Dumper($params);
my $job_id = $srv->search_domains($params);


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

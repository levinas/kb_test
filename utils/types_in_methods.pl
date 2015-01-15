#! /usr/bin/env perl

use strict;
use Data::Dumper;
use Getopt::Long;
use JSON;

my $usage = "Usage: $0 [ -b branch(D=dev) ] method-list\n\n";

my ($help, $branch);

GetOptions("h|help" => \$help,
           "b|branch=s" => \$branch,
	  ) or die("Error in command line arguments\n");

$help and die $usage;

my $file = shift @ARGV;
my @methods;
@methods = split(/\s+/, `cat $file`) if $file;
@methods = all_methods() unless @methods;

# get_method_info('assemble_contigset_from_reads');
get_method_info($_) for @methods;


sub get_method_info {
    my ($method, $branch) = @_;
    $branch ||= 'dev';
    my $url = "https://github.com/kbase/narrative_method_specs/raw/$branch/methods/$method/spec.json";
    my $json = `curl -s -L $url`;
    my $spec = decode_json($json);
    my $params = $spec->{parameters};
    return unless $params && @$params;
    for my $p (@$params) {
        my $id = $p->{id};
        my $t = $p->{text_options} or next;
        my $types = $t->{valid_ws_types} or next; @$types or next;
        my $io = $t->{is_output_name} ? 'OUT' : 'IN';
        my $optional = $p->{optional} ? 'optional' : '';
        my $advanced = $p->{advanced} ? 'advanced' : '';
        for my $t (@$types) {
            print join("\t", $method, $id, $t, $io, $optional, $advanced) . "\n";
        }
    }
}

sub all_methods {
    my ($branch) = @_;
    $branch ||= 'dev';
    my $json = `curl -s -L https://api.github.com/repos/kbase/narrative_method_specs/contents/methods`;
    my $list = decode_json($json);
    my @methods = map { $_->{name} } @$list;
    wantarray ? @methods : \@methods;
}


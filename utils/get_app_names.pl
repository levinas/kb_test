#! /usr/bin/env perl

use strict;
use Data::Dumper;
use Getopt::Long;
use JSON;

my $usage = "Usage: $0 [ -b branch(D=dev) ] \n\n";

my ($help, $branch);

GetOptions("h|help" => \$help,
           "b|branch=s" => \$branch,
	  ) or die("Error in command line arguments\n");

$help and die $usage;

my @apps = all_apps();
my @methods = all_apps('methods');

my $hash;
for (@apps) { $hash->{app}->{$_} = get_app_display_name($_) }
for (@methods) { $hash->{method}->{$_} = get_app_display_name($_, 'methods') }

print to_json($hash, {pretty => 1});

# print get_app_display_name('build_fba_model'). "\n";

sub get_app_display_name {
    my ($app, $type, $branch) = @_;
    $type ||= 'apps';
    $branch ||= 'dev';
    my $url = "https://github.com/kbase/narrative_method_specs/raw/$branch/$type/$app/display.yaml";
    my $yaml = `curl -s -L $url`;
    my ($name) = $yaml =~ /name\s*:\s*(.*\S)/;
    return $name;
}


sub all_apps {
    my ($type) = @_;
    $type ||= 'apps';
    my $json = `curl -s -L https://api.github.com/repos/kbase/narrative_method_specs/contents/$type`;
    my $list = decode_json($json);
    my @apps = map { $_->{name} } @$list;
    wantarray ? @apps : \@apps;
}


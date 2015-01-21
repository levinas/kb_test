#! /usr/bin/env perl

use strict;
use Data::Dumper;
use JSON;

use Bio::KBase::NarrativeJobService::Client;

my $usage = "Usage: $0 app.json\n\n";

my $input = shift @ARGV or die $usage;
my $token = $ENV{KB_AUTH_TOKEN};
my $url   = "http://narrative-dev.kbase.us:8200"; # https://github.com/kbase/narrative/blob/develop/src/config.json
my $njs   = new Bio::KBase::NarrativeJobService::Client($url, $token);
my $app   = decode_json(slurp_input($input)); add_token_to_params($app, $token);
my $name  = $app->{name};
my $start = time();
my $state = $njs->run_app($app);
my $job   = $state->{job_id} or die "Could not start app '$app'";
my $pos   = $state->{position};

print STDERR "Running app '$name' on '$input'...\n";
print STDERR "job = $job, position = $pos\n";
my $state = wait_job($job);
my $time  = time_readable(time() - $start);
my $final = $state->{job_state};
print STDERR "Job completed with status '$final' in $time: \n";
print STDERR to_json($state, {pretty => 1});
print STDERR to_json($app, {pretty => 1}) if $final !~ /completed/;

my $errors = $state->{step_errors};
my $outputs = $state->{step_outputs};

$errors && !%$errors or die "Job returned errors\n";
$outputs && %$outputs or die "Job returned no outputs\n";

sub add_token_to_params {
    my ($p, $token) = @_;
    my $steps = $p->{steps};
    return unless $steps && ref($steps) eq 'ARRAY' && @$steps;
    for (my $i = 0; $i < @$steps; $i++) {
        my $params = $steps->[$i]->{parameters};
        next unless $params && ref($params) eq 'ARRAY' && @$params;
        for (my $j = 0; $j < @$params; $j++) {
            if ($params->[$j]->{label} eq "token") {
                $params->[$j]->{value} = $token;
            }
        }
    }
}

sub wait_job {
    my ($job) = @_;
    my $state = $njs->check_app_state($job);
    my $seconds = 5;
    my $minutues = 1;
    my $cycles;
    while ($state->{job_state} !~ /(completed|suspend)/) {
        $state && $state->{job_state} or die "Could not query job state: $job";
        # Running states: queued, running, in-progress
        print STDERR "Checking job state: $state->{job_state}\n" if ($cycles++ % int($minutues * 60 / $seconds)) == 0;
        sleep $seconds;
        $state = $njs->check_app_state($job);
    }
    return $state;
}

sub time_readable {
    my ($s) = @_;
    my ($m, $h);
    if ($s > 60) {
        $m = int($s / 60);
        $s = $s % 60;
    }
    if ($m > 60) {
        $h = int($m / 60);
        $m = $m % 60;
    }
    my $ret = $s."s";
    $ret = $m."m".$ret if $m;
    $ret = $h."h".$ret if $h;
    return $ret;
}


#-----------------------------------------------------------------------------
#  Read the entire contents of a file or stream into a string.  This command
#  if similar to $string = join( '', <FH> ), but reads the input by blocks.
#
#     $string = slurp_input( )                 # \*STDIN
#     $string = slurp_input(  $filename )
#     $string = slurp_input( \*FILEHANDLE )
#
#-----------------------------------------------------------------------------
sub slurp_input
{
    my $file = shift;
    my ( $fh, $close );
    if ( ref $file eq 'GLOB' )
    {
        $fh = $file;
    }
    elsif ( $file )
    {
        if    ( -f $file )                    { $file = "<$file" }
        elsif ( $_[0] =~ /^<(.*)$/ && -f $1 ) { }  # Explicit read
        else                                  { return undef }
        open $fh, $file or return undef;
        $close = 1;
    }
    else
    {
        $fh = \*STDIN;
    }

    my $out =      '';
    my $inc = 1048576;
    my $end =       0;
    my $read;
    while ( $read = read( $fh, $out, $inc, $end ) ) { $end += $read }
    close $fh if $close;

    $out;
}

#-----------------------------------------------------------------------------
#  Print text to a file.
#
#     print_output( $string )                 # \*STDIN
#     print_output( $string, $filename )
#     print_output( $string, \*FILEHANDLE )
#
#-----------------------------------------------------------------------------
sub print_output
{
    my ($text, $file) = @_;

    #  Null string or undef
    print $text if ( ! defined( $file ) || ( $file eq "" ) );

    #  FILEHANDLE
    print $file, $text if ( ref( $file ) eq "GLOB" );

    #  Some other kind of reference; return the unused value
    return if ref( $file );

    #  File name
    my $fh;
    open( $fh, '>', $file ) || die "Could not open output $file\n";
    print $fh $text;
    close( $fh );
}

sub run { system(@_) == 0 or confess("FAILED: ". join(" ", @_)); }

#! /usr/bin/env perl

use strict;
use Data::Dumper;
use Getopt::Long;
use JSON;

Getopt::Long::Configure("pass_through");

my $usage = <<"End_of_Usage";

usage: $0 [ options ] 

Input:

    --assembly_input   filename     - json input of KBaseAssembly.AssemblyInput typed object
    --description      text         - description of assembly job

Output:

    --output_contigset filename     - required json output of KBaseGenomes.ContigSet typed object

Method (only one is used: pipeline > assembler > recipe):

    --assembler        string       - assembler
    --recipe           string       - assembly recipe
    --pipeline         string       - multistep assembly pipeline (e.g., "tagdust velvet")

End_of_Usage

my ($help, $assembly_input, $assembly_input, $description,
    $output_contigset, $recipe, $assembler, $pipeline);

GetOptions("h|help"               => \$help,
           "i|assembly_input=s"   => \$assembly_input,
           "d|description=s"      => \$description,
           "o|output_contigset=s" => \$output_contigset,
           "r|recipe=s"           => \$recipe,
           "a|assembler=s"        => \$assembler,
           "p|pipeline=s"         => \$pipeline,
	  ) or die("Error in command line arguments\n");

$help and die $usage;

($recipe || $assembler || $pipeline) && $output_contigset or die $usage;

verify_cmd("ar-run") and verify_cmd("ar-get");

my $method = $pipeline  ? "-p '$pipeline'" :
             $assembler ? "-a $assembler"  :
                          "-r $recipe";

my @ai_params = parse_assembly_input($assembly_input);

my $cmd = join(" ", @ai_params);
$cmd = "ar-run $method $cmd | ar-get -w -p | ./fasta_to_contigset.pl > $output_contigset";
print "$cmd\n";

run($cmd);

sub parse_assembly_input {
    my ($json) = @_;
    return unless $json && -s $json;
    my $ai = decode_json(slurp_input($json));
    my @params;
    
    my ($pes, $ses, $ref) = ($ai->{paired_end_libs}, $ai->{single_end_libs}, $ai->{references});

    for (@$pes) { push @params, parse_pe_lib($_) }
    for (@$ses) { push @params, parse_se_lib($_) }
    for (@$ref) { push @params, parse_ref($_) }

    return @params;
}

sub parse_pe_lib {
    my ($lib) = @_;
    my @params;
    push @params, "--pair_url";
    push @params, handle_to_url($lib->{handle_1});
    push @params, handle_to_url($lib->{handle_2});
    my @ks = qw(insert_size_mean insert_size_std_dev);
    for my $k (@ks) {
        push @params, $k."=".$lib->{$k} if $lib->{$k};
    }
    return @params;
}

sub parse_se_lib {
    my ($lib) = @_;
    my @params;
    push @params, "--single_url";
    push @params, handle_to_url($lib->{handle});
    return @params;
}

sub parse_ref {
    my ($ref) = @_;
    my @params;
    push @params, "--reference_url";
    push @params, handle_to_url($ref->{handle});
    return @params;
}

sub handle_to_url {
    my ($h) = @_;
    my $url = sprintf "'%s/node/%s?download'", $h->{url}, $h->{id};
}

sub verify_cmd {
    my ($cmd) = @_;
    system("which $cmd >/dev/null") == 0 or die "Command not found: $cmd\n";
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
    print $fh, $text;
    close( $fh );
}

sub run { system(@_) == 0 or confess("FAILED: ". join(" ", @_)); }

#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/assemble_contigset_from_reads/* .

njs-run-step --param_file input_ar.json   --command $KB_TOP/bin/assemble_contigset_from_reads.pl
njs-run-step --param_file input_libs.json --command $KB_TOP/bin/assemble_contigset_from_reads.pl

#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/assemble_contigset_from_reads/* .

njs-run-step --params input_ar.json   ./assemble_contigset_from_reads.pl
njs-run-step --params input_libs.json ./assemble_contigset_from_reads.pl

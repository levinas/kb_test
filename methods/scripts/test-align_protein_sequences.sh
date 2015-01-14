#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/align_protein_sequences/* .

perl test_construct_multiple_alignment.pl


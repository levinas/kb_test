#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/compare_two_proteomes/* .

perl test_blast_proteomes.pl


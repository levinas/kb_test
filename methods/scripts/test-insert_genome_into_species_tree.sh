#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/insert_genome_into_species_tree/* .

perl test_construct_species_tree.pl

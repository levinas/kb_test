#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/simulate_growth_on_a_phenotype_set/* .

perl test_construct_species_tree.pl

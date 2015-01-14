#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/simulate_growth_on_a_phenotype_set/* .

njs-run-fba-modeling simulate_phenotypes ecoli.pheno.json

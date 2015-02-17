#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/simulate_growth_on_a_phenotype_set/* .

export FBA_SERVER_MODE=1
njs-run-fba-modeling --command simulate_phenotypes --param_file ecoli.pheno.json

#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/gapfill_a_metabolic_model/* .

export FBA_SERVER_MODE=1
njs-run-fba-modeling --command gapfill_model --param_file ecoli.model.json

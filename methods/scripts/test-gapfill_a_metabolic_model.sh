#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/gapfill_a_metabolic_model/* .

njs-run-fba-modeling --command gapfill_model --param_file ecoli.model.json

#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/gapfill_a_metabolic_model/* .

njs-run-fba-modeling gapfill_model ecoli.model.json

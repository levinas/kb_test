#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/run_flux_balance_analysis/* .

njs-run-fba-modeling --command runfba --param_file ecoli.model.gf.json

#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/build_a_metabolic_model/* .

njs-run-fba-modeling genome_to_fbamodel ecoli.json

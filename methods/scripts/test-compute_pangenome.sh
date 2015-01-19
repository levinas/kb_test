#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/compute_pangenome/* .

njs-run-fba-modeling --command build_pangenome --param_file yersinia.set.json

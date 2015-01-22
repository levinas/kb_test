#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/heatmap_from_abundance_profile/* .

njs-run-step --param_file input_func_matrix.json --command $KB_TOP/bin/mg-compare-heatmap


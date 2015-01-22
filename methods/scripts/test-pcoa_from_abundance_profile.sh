#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/pcoa_from_abundance_profile/* .

njs-run-step --param_file input_func_matrix.json --command $KB_TOP/bin/mg-compare-pcoa
njs-run-step --param_file input_func_matrix_norm.json --command $KB_TOP/bin/mg-compare-pcoa


#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/normalize_abundance_profile/* .

njs-run-step --param_file input_func_matrix.json --command $KB_TOP/bin/mg-compare-normalize
njs-run-step --param_file input_tax_matrix.json  --command $KB_TOP/bin/mg-compare-normalize


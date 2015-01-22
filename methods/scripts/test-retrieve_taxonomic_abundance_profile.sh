#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/retrieve_taxonomic_abundance_profile/* .

njs-run-step --param_file input_mg_collection.json --command $KB_TOP/bin/mg-compare-taxa


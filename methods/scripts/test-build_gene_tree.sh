#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/build_gene_tree/* .

perl test_construct_tree_for_alignment.pl

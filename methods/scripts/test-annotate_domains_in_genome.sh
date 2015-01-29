#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/annotate_domains_in_genome/* .

perl test_annotate_domains_in_genome.pl


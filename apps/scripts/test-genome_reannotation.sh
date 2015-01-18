#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

rsync -avp --del $DIR/genome_reannotation .

for f in genome_reannotation/input*.json; do
  $DIR/../../utils/run_njs_app.pl $f
done

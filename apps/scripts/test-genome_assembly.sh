#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

rsync -avp --del $DIR/genome_assembly .

for f in genome_assembly/input*.json; do
  $DIR/../../utils/run_njs_app.pl $f
done

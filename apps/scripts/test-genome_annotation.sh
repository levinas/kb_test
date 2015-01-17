#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

rsync -avp --del $DIR/genome_annotation .

for f in genome_annotation/input*.json; do
  $DIR/../../utils/run_njs_app.pl $f
done

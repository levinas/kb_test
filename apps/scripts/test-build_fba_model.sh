#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

rsync -avp --del $DIR/build_fba_model .

for f in build_fba_model/input*.json; do
  $DIR/../../utils/run_njs_app.pl $f
done

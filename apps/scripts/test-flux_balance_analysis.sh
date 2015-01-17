#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

rsync -avp --del $DIR/flux_balance_analysis .

for f in flux_balance_analysis/input*.json; do
  $DIR/../../utils/run_njs_app.pl $f
done

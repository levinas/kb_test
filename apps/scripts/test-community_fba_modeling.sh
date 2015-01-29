#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

rsync -avp --del $DIR/community_fba_modeling .

for f in community_fba_modeling/input*.json; do
  $DIR/../../utils/run_njs_app.pl $f
done

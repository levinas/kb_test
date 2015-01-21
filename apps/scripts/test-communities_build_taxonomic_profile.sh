#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

rsync -avp --del $DIR/communities_build_taxonomic_profile .

for f in communities_build_taxonomic_profile/input*.json; do
  $DIR/../../utils/run_njs_app.pl $f
done

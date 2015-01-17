#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

rsync -avp --del $DIR/build_plant_metabolic_model .

for f in build_plant_metabolic_model/input*.json; do
  $DIR/../../utils/run_njs_app.pl $f
done

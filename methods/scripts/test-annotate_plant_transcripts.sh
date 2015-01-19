#! /bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cp $DIR/annotate_plant_transcripts/* .

njs-run-genome-annotation --command annotate_genome --param_file Ptrichocarpa.JGI3.0.json

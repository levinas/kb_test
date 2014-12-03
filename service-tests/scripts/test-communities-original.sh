
rsync -avp --del /kb/dev_container/modules/communities_api/test/ test

for f in test/client-tests/*.t; do
  echo "Testing $f..."
  perl $f |tee $f.tap
done

for f in test/script-tests/*.t; do
  echo "Testing $f..."
  perl $f |tee $f.tap
done

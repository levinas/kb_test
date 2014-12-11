
rsync -avp --del /kb/dev_container/modules/communities_api/test/ test

# for f in test/script-tests/*.t; do
for f in test/script-tests/*merge.t; do
  echo "Testing $f..."
  # first argument is path to test data, second path to output directory (default ./ )
  # perl $f /kb/dev_container/modules/communities_api/test/data/ |tee $f.tap
  prove --timer --formatter=TAP::Formatter::JUnit $f :: /kb/dev_container/modules/communities_api/test/data/ > $f.junit.xml
done

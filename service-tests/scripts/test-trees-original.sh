
rsync -avp --del /kb/dev_container/modules/trees/test/ test

sed -i 's|^my $URL  = "http://127.0.0.1:7047"|my $URL = "https://kbase.us/services/trees"|' test/perl-tests/TreeTestConfig.pm

for f in test/perl-tests/*.t; do
  echo "Testing $f..."
  perl $f |tee $f.tap
done

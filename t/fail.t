use strict;
use warnings;
use lib qw( ./lib ../lib );

use Data::Dumper;

use Test::More;
plan(tests => 5);

use_ok('CSS::Simple');

#aggregate all our warnings, this test is specifically to determine how errors/warns are handled
my @warnings = ();
BEGIN { $SIG{'__WARN__'} = sub { push @warnings, $_[0] } }

my $css = <<END;
.foo {
	color?: red;
}
END

#test to ensure that fatal errors are in fact fatal
my $fatal = CSS::Simple->new({ suppress_errors => 0 });

eval {
  $fatal->read({css => $css});
};

ok($@ =~ /^Invalid or unexpected property/);

@warnings = (); # clear all preceding warnings and start over

#test to ensure that when fatals are disabled that we only get warnings
my $supressed = CSS::Simple->new({ suppress_errors => 1 });

eval {
  $supressed->read({css => $css});
};

ok(scalar @warnings == 1);
ok($warnings[0] =~ /^Invalid or unexpected property/);

#test to ensure that default errors are in fact fatal
my $fatal = CSS::Simple->new();

eval {
  $fatal->read({css => $css});
};

ok($@ =~ /^Invalid or unexpected property/);

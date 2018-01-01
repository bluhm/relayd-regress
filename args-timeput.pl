# test that 2 seconds timeout does not occur while client writes for 4 seconds

use strict;
use warnings;

our %args = (
    client => {
	func => \&write_char,
	len => 5,
	sleep => 1,
	timefile => "",
    },
    relayd => {
	relay => [ "session timeout 2" ],
    },
    len => 5,
);

1;

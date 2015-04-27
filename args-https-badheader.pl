# test https connection over http relay
# The client writes an incomplete header and closes the connection.

use strict;
use warnings;

our %args = (
    client => {
	func => sub {
	    print "GET ";  # missing new line
	},
	nocheck => 1,
	ssl => 1,
    },
    relayd => {
	protocol => [ "http",
	    "match request header log foo",
	    "match response header log bar",
	],
	forwardssl => 1,
	listenssl => 1,

    },
    server => {
	noserver => 1,
	nocheck => 1,
    },
);

1;

# test http connection over http relay
# The client writes an bad header line and an additional line.
# Check that the relay handles the next line after the error correctly.

use strict;
use warnings;

our %args = (
    client => {
	func => sub {
	    print "GET /index.html HTTP\nHost: foo.example.com";  # no version
	},
	nocheck => 1,
    },
    relayd => {
	protocol => [ "http",
	    "match request header log foo",
	    "match response header log bar",
	],
	loggrep => {
	    qr/session 1 .*, done/ => 1,
	},
    },
    server => {
	noserver => 1,
	nocheck => 1,
    },
);

1;

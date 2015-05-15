# test http connection with chunks over http relay
# The client writes a bad header line and an additional line.
# Check that the relay handles the next line after the error correctly.

use strict;
use warnings;

my @lengths = (4, 3);
our %args = (
    client => {
	func => sub {
	    my $self = shift;
	    print <<'EOF';
PUT /server-check-content-length-4.html HTTP/1.1
Content-Length: 4
Host: foo.bar

123
XXX
PUT /server-check-content-length-3.html HTTP/1.1
Host: foo.bar
Content-Length: 3

12
EOF
	    print STDERR "LEN: 4\n";
	    print STDERR "LEN: 3\n";
	    # relayd does not forward the first request if the second one
	    # is invalid.  So do not expect any response.
	    #http_response($self, "without len");
	},
	http_vers => ["1.1"],
	lengths => \@lengths,
	method => "PUT",
    },
    relayd => {
	protocol => [ "http",
	    "match request header log foo",
	    "match response header log bar",
	],
	loggrep => {
	    qr/, malformed, PUT/ => 1,
	},
    },
    server => {
	func => \&http_server,
	# The server does not get any connection.
	noserver => 1,
	nocheck => 1,
    },
    lengths => \@lengths,
);

1;

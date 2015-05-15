# test http connection over http relay
# The client writes an bad header line and an additional line.
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
PUT /server-check-content-length-3.html HTTP/1.1
Host: foo.bar
Content-Length: 3

12
EOF
	    print STDERR "LEN: 4\n";
	    print STDERR "LEN: 3\n";
	    http_response($self, "without len");
	    http_response($self, "without len");
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
	    qr/, (?:done|last write \(done\), PUT)/ => 1,
	},
    },
    server => {
	func => \&http_server,
    },
    lengths => \@lengths,
);

1;

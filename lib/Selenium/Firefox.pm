package Selenium::Firefox;
$Selenium::Firefox::VERSION = '0.2702';
# ABSTRACT: Use FirefoxDriver without a Selenium server
use Moo;
use Selenium::CanStartBinary::FindBinary qw/coerce_firefox_binary/;
extends 'Selenium::Remote::Driver';


has '+browser_name' => (
    is => 'ro',
    default => sub { 'firefox' }
);


has 'binary' => (
    is => 'lazy',
    coerce => \&coerce_firefox_binary,
    default => sub { 'firefox' },
    predicate => 1
);


has 'binary_port' => (
    is => 'lazy',
    default => sub { 9090 }
);

has '_binary_args' => (
    is => 'lazy',
    builder => sub {
        my ($self) = @_;

        my $args = ' -no-remote';
        if( $self->marionette_enabled ) {
            $args .= ' -marionette';
        }
        return $args;
    }
);

has '+wd_context_prefix' => (
    is => 'ro',
    default => sub { '/hub' }
);


has 'marionette_binary_port' => (
    is => 'lazy',
    default => sub { 2828 }
);


has 'marionette_enabled' => (
    is  => 'lazy',
    default => 0
);

with 'Selenium::CanStartBinary';


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Selenium::Firefox - Use FirefoxDriver without a Selenium server

=head1 VERSION

version 0.2702

=head1 SYNOPSIS

    my $driver = Selenium::Firefox->new;
    my $driver = Selenium::Firefox->new( marionette_enabled => 1 );

=head1 DESCRIPTION

This class allows you to use the FirefoxDriver without needing the JRE
or a selenium server running. When you refrain from passing the
C<remote_server_addr> and C<port> arguments, we will search for the
Firefox executable in your $PATH. We'll try to start the binary
connect to it, shutting it down at the end of the test.

If the Firefox application is not found in the expected places, we'll
fall back to the default L<Selenium::Remote::Driver> behavior of
assuming defaults of 127.0.0.1:4444 after waiting a few seconds.

If you specify a remote server address, or a port, we'll assume you
know what you're doing and take no additional behavior.

If you're curious whether your Selenium::Firefox instance is using a
separate Firefox binary, or through the selenium server, you can check
the C<binary_mode> attr after instantiation.

=head1 ATTRIBUTES

=head2 binary

Optional: specify the path to your binary. If you don't specify
anything, we'll try to find it on our own in the default installation
paths for Firefox. If your Firefox is elsewhere, we probably won't be
able to find it, so you may be well served by specifying it yourself.

=head2 binary_port

Optional: specify the port that we should bind to. If you don't
specify anything, we'll default to the driver's default port. Since
there's no a priori guarantee that this will be an open port, this is
_not_ necessarily the port that we end up using - if the port here is
already bound, we'll search above it until we find an open one.

See L<Selenium::CanStartBinary/port> for more details, and
L<Selenium::Remote::Driver/port> after instantiation to see what the
actual port turned out to be.

=head2 marionette_binary_port

Optional: specify the port that we should bind marionette to. If you don't
specify anything, we'll default to the marionette's default port. Since
there's no a priori guarantee that this will be an open port, this is
_not_ necessarily the port that we end up using - if the port here is
already bound, we'll search above it until we find an open one.

See L<Selenium::CanStartBinary/port> for more details, and
L<Selenium::Remote::Driver/port> after instantiation to see what the
actual port turned out to be.

    Selenium::Firefox->new(
        marionette_enabled     => 1,
        marionette_binary_port => 12345,
    );

=head2 marionette_enabled

Optional: specify whether L<marionette|https://developer.mozilla.org/en-US/docs/Mozilla/QA/Marionette>
should be enabled or not. If you enable the marionette_enabled flag,
Firefox is launched with marionette server listening to
C<marionette_binary_port>.

The firefox binary must have been built with this funtionality and it's
available in L<all recent Firefox binaries|https://developer.mozilla.org/en-US/docs/Mozilla/QA/Marionette/Builds>.

Note: L<Selenium::Remote::Driver> does not yet provide a marionette
client. It's up to the user to use a client or a marionette-to-webdriver
proxy to communicate with the marionette server.

    Selenium::Firefox->new( marionette_enabled => 1 );

and Firefox will have 2 ports open. One for webdriver and one
for marionette:

    netstat -tlp | grep firefox
    tcp    0    0    localhost:9090    *:*    LISTEN    23456/firefox
    tcp    0    0    localhost:2828    *:*    LISTEN    23456/firefox

=head2 custom_args

Optional: specify any additional command line arguments you'd like
invoked during the binary startup. See
L<Selenium::CanStartBinary/custom_args> for more information.

=head2 startup_timeout

Optional: specify how long to wait for the binary to start itself and
listen on its port. The default duration is arbitrarily 10 seconds. It
accepts an integer number of seconds to wait: the following will wait
up to 20 seconds:

    Selenium::Firefox->new( startup_timeout => 20 );

See L<Selenium::CanStartBinary/startup_timeout> for more information.

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Selenium::Remote::Driver|Selenium::Remote::Driver>

=back

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/gempesaw/Selenium-Remote-Driver/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHORS

Current Maintainers:

=over 4

=item *

Daniel Gempesaw <gempesaw@gmail.com>

=item *

Emmanuel Peroumalnaïk <peroumalnaik.emmanuel@gmail.com>

=back

Previous maintainers:

=over 4

=item *

Luke Closs <cpan@5thplane.com>

=item *

Mark Stosberg <mark@stosberg.com>

=back

Original authors:

=over 4

=item *

Aditya Ivaturi <ivaturi@gmail.com>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2010-2011 Aditya Ivaturi, Gordon Child

Copyright (c) 2014-2015 Daniel Gempesaw

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

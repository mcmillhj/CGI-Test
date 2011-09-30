package CGI::Test::Page::Real;
use strict;
####################################################################
# $Id: Real.pm 411 2011-09-26 11:19:30Z nohuhu@nohuhu.org $
# $Name: cgi-test_0-104_t1 $
####################################################################
#
#  Copyright (c) 2001, Raphael Manfredi
#
#  You may redistribute only under the terms of the Artistic License,
#  as specified in the README file that comes with the distribution.

#
# An abstract interface to a real page, which is the result of a valid output
# and not an HTTP error.  The concrete representation is defined by heirs,
# depending on the Content-Type.
#

use Getargs::Long;
use Log::Agent;

require CGI::Test::Page;
use base qw(CGI::Test::Page);

#
# ->new
#
# Creation routine
#
sub new
{
    logconfess "deferred";
}

#
# Attribute access
#

sub raw_content
{
    my $this = shift;
    return $this->{raw_content};
}

sub uri
{
    my $this = shift;
    return $this->{uri};
}

sub raw_content_ref
{
    my $this = shift;
    return \$this->{raw_content};
}

#
# ->_init
#
# Initialize common attributes
#
sub _init
{
    my $this = shift;
    my ($server, $file, $ctype, $user, $uri) = cxgetargs(
        @_, {-strict => 0, -extra => 0},
        -server       => 'CGI::Test',    # XXX may be extended one day
        -file         => 's',
        -content_type => 's',
        -user         => undef,
        -uri          => 'URI',
        );
    $this->{server}       = $server;
    $this->{content_type} = $ctype;
    $this->{user}         = $user;
    $this->{uri}          = $uri;
    $this->_read_raw_content($file);
    return;
}

#
# ->_read_raw_content
#
# Read file content verbatim into `raw_content', skipping header.
#
# Even in the case of an HTML content, reading the whole thing into memory
# as a big happy string means we can issue regexp queries.
#
sub _read_raw_content
{
    my $this = shift;
    my ($file) = @_;

    local *FILE;
    open(FILE, $file) || logdie "can't open $file: $!";
    my $size = -s FILE;

    $this->{raw_content} = ' ' x -s (FILE);    # Pre-extend buffer

    local $_;
    while (<FILE>)
    {                                          # Skip header
        last if /^\r?$/;
    }

    local $/ = undef;                          # Will slurp remaining
    $this->{raw_content} = <FILE>;
    close FILE;

    return;
}

1;

=head1 NAME

CGI::Test::Page::Real - Abstract representation of a real page

=head1 SYNOPSIS

 # Inherits from CGI::Test::Page
 # $page holds a CGI::Test::Page::Real object

 use CGI::Test;

 ok 1, $page->raw_content =~ /test is ok/;
 ok 2, $page->uri->scheme eq "http";
 ok 3, $page->content_type !~ /html/;

=head1 DESCRIPTION

This class is the representation of a real page, i.e. something physically
returned by the server and which is not an error.

=head1 INTERFACE

The interface is the same as the one described in L<CGI::Test::Page>, with
the following additions:

=over 4

=item C<raw_content>

Returns the raw content of the page, as a string.

=item C<raw_content_ref>

Returns a reference to the raw content of the page, to avoid making yet
another copy.

=item C<uri>

The URI object, identifying the page we requested.

=back

=head1 WEBSITE

You can find information about CGI::Test and other related modules at:

   http://cgi-test.sourceforge.net

=head1 PUBLIC CVS SERVER

CGI::Test now has a publicly accessible CVS server provided by
SourceForge (www.sourceforge.net).  You can access it by going to:

    http://sourceforge.net/cvs/?group_id=89570

=head1 AUTHORS

The original author is Raphael Manfredi F<E<lt>Raphael_Manfredi@pobox.comE<gt>>. 

Send bug reports, hints, tips, suggestions to Steven Hilton at <mshiltonj@mshiltonj.com>

=head1 SEE ALSO

CGI::Test::Page(3), CGI::Test::Page::HTML(3), CGI::Test::Page::Other(3),
CGI::Test::Page::Text(3), URI(3).

=cut


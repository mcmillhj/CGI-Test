package CGI::Test::Form::Widget::Hidden;
use strict;
##################################################################
# $Id: Hidden.pm 411 2011-09-26 11:19:30Z nohuhu@nohuhu.org $
# $Name: cgi-test_0-104_t1 $
##################################################################
#
#  Copyright (c) 2001, Raphael Manfredi
#
#  You may redistribute only under the terms of the Artistic License,
#  as specified in the README file that comes with the distribution.

#
# This class models a FORM hidden field.
#

require CGI::Test::Form::Widget;
use base qw(CGI::Test::Form::Widget);

use Log::Agent;

#
# %attr
#
# Defines which HTML attributes we should look at within the node, and how
# to translate that into class attributes.
#

my %attr = ('name'     => 'name',
            'value'    => 'value',
            'disabled' => 'is_disabled',
            );

#
# ->_init
#
# Per-widget initialization routine.
# Parse HTML node to determine our specific parameters.
#
sub _init
{
    my $this = shift;
    my ($node) = shift;
    $this->_parse_attr($node, \%attr);
    return;
}

#
# ->_is_successful		-- defined
#
# Is the enabled widget "successful", according to W3C's specs?
# Any hidden field with a VALUE attribute is.
#
sub _is_successful
{
    my $this = shift;
    return defined $this->value();
}

#
# Attribute access
#

sub gui_type
{
    return "hidden field";
}

#
# Global widget predicates
#

sub is_read_only
{
    return 1;
}

#
# High-level classification predicates
#

sub is_hidden
{
    return 1;
}

1;

=head1 NAME

CGI::Test::Form::Widget::Hidden - A hidden field

=head1 SYNOPSIS

 # Inherits from CGI::Test::Form::Widget

=head1 DESCRIPTION

This class represents a hidden field, which is meant to be resent as-is
upon submit.  Such a widget is therefore read-only.

The interface is the same as the one described
in L<CGI::Test::Form::Widget>.

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

CGI::Test::Form::Widget(3).

=cut


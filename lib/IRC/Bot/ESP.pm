package IRC::Bot::ESP;

use strict;
use warnings;

use base qw( Bot::BasicBot );

our $VERSION = '0.1';

my $sendmail = "/usr/sbin/sendmail -t";

sub said {
    my $self = shift;
    my $args = shift;

    return if ($self->ignore_nick($args->{who}));

    if (my ($nick,$msg) = $args->{body} =~ /^([\w\-]+):\s*esping(.*)$/) {
        return "$args->{who}: sorry, I don't know how to electro-shock ping $nick" unless exists $self->{nickmap}->{$nick};
        return "$args->{who}: sorry, I don't know $nick\'s number" unless exists $self->{nickmap}->{$nick}->{number};
        return "$args->{who}: sorry, I don't know $nick\'s carrier" unless exists $self->{nickmap}->{$nick}->{carrier};
        open(SENDMAIL, "|$sendmail") or die "Cannot open $sendmail: $!";
        print SENDMAIL "From: espbot\@meridian.tamucc.edu\n";
        print SENDMAIL "To: $self->{nickmap}->{$nick}->{number}\@$self->{carriermap}->{$self->{nickmap}->{$nick}->{carrier}}\n";
        print SENDMAIL "Content-type: text/plain\n\n";
        print SENDMAIL "$args->{who} is electro-shock pinging you on $args->{channel}";
        $msg =~ s/^\s+//;
        print SENDMAIL ": $msg" if $msg;
        close(SENDMAIL);
        return "$args->{who}: electro-shock pinging $nick";
    }
    return undef;
}

1;

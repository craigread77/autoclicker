use strict;
use warnings;
use v5.16;
use Win32::GuiTest qw( SendMouse FindWindowLike GetWindowText SetForegroundWindow SendKeys IsKeyPressed );
use Time::HiRes qw(usleep sleep);

# Usage:
# auto_clicker.pl <minimum delay (ms)> <maximum delay (ms)> <'1' or '2' (single/double click)> <maximum number of clicks>{optional}
# examples
#
# auto_clicker.pl 1000 3000 1
# Single clicks with 1000 to 3000 ms delay in between
#
# auto_clicker.pl 1000 3000 2
# Double clicks with 1000 to 3000 ms delay in between
#
# auto_clicker.pl 1000 3000 2 850
# Double clicks with 1000 to 3000 ms delay in between. Stops after 850 loops

die 'incorrect arguments. See usage.' unless defined $ARGV[0] && defined $ARGV[1] && defined $ARGV[2];

my ($min, $max) = ($ARGV[0], $ARGV[1]);

# Check for double click
my $click;
if ($ARGV[2] && $ARGV[2] eq '2') {
    $click = 2;
} else {
    $click = 1;
}

my $limit = $ARGV[3] // undef;
my $count = 0;

my @windows = FindWindowLike(0, "^RuneLite");
for (@windows) {
    print "$_>\t'", GetWindowText($_), "'\n";
    SetForegroundWindow($_);
    usleep(100000);
}



while (defined $limit ? $limit > $count : 1 == 1) {
    my $delay = ($min + int(rand($max - $min))) * 1000;
    
    if ($click == 2) {
        my $dclick_delay = ((30 + int(rand(70 - 20))) * 1000);
        SendMouse "{LEFTCLICK}";
        say 'click';
        usleep($dclick_delay);
        say "Double-click delay: " . ($dclick_delay / 1000) . " ms";
        SendMouse "{LEFTCLICK}";
    } else {
        SendMouse "{LEFTCLICK}";
        say 'click';
    }
    
    say "Next click in: " . ($delay / 1000000) ."s";
    usleep($delay);
    $count++;
}

say "Terminated after $count clicks";



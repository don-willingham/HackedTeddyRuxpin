#!/usr/bin/perl
use strict;
use Linux::Joystick;

sub servo
{
   my $SERVO;
   my ($num, $pct) = @_;
   if (open SERVO, ">/dev/servoblaster") {
      my $out = $num."=".$pct."%\n";
      print $out;
      print SERVO $out;
      close SERVO;
   }
}

sub axisToServo {
   my ($num, $x, $y) = @_;
   $x = abs($x);
   $y = abs($y);
   my $max = ($x >= $y) ? $x : $y;
   my $pct = $max / 32768.0 * 100.0;
   print "num=$num x=$x y=$y pct=$pct\n";
   servo($num, $pct);
   if (0 == $num) {
      servo(2, $pct);
   }
}

my @axisValue = (0, 0, 0, 0);
sub mapAxis {
   my ($axis, $value) = @_;
   if (($axis >= 0) && ($axis < 4)) {
      $axisValue[$axis] = $value;
      if ($axis < 2) {
         axisToServo(0, $axisValue[0], $axisValue[1]);
      } else {
         axisToServo(1, $axisValue[2], $axisValue[3]);
      }
   }
}

my $js = new Linux::Joystick;
my $event;

print "Joystick has " . $js->buttonCount() . " buttons ".
      "and " . $js->axisCount() . " axes.\n";
while( $event = $js->nextEvent ) {
   print "Event type: " . $event->type . ", ";
   if($event->isButton) {
      print "Button " . $event->button;
      if($event->buttonDown) {
         print " pressed";
      } else {
         print " released";
      } 
   } elsif($event->isAxis) {
      mapAxis($event->axis, $event->axisValue);
   } else { # should never happen
      print "Unknown event " . $event->hexDump;
   }

   print "\n";
}

# if the while loop terminates, we got a false (undefined) event:
die "Error reading joystick: " . $js->errorString;

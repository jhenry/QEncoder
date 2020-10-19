#!/usr/bin/perl
use strict; # always!
use File::Queue;
use Config::Tiny;
my $q_num=$ARGV[0];

my $config = Config::Tiny->read( 'config.config' );
my $daemonpath = $config->{_}->{daemonpath};

# Set Path to queues 
my $q_file="$daemonpath/$q_num";

print "Setting up new queue at $daemonpath...\n";

my $q = new File::Queue (File => $q_file,Mode=>0774 );
print "Starting up $q_file ...\n";
$| = 1;
while (1) {
    my $elem1 = $q->deq(); 
    if ($elem1) {
        my $datestring = localtime();
        print "new job\n$elem1\n";
        print "Job Start time $datestring\n";
        print `$elem1`;
        $datestring = localtime();
        print "Job end $elem1\nqtime $datestring\n";

    } else {
        #           print "nothing to do\n";
        sleep 60;
    }
}


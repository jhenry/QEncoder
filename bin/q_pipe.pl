#!/usr/bin/perl
use strict; 
use File::Queue;
use Config::Tiny;
my $job=$ARGV[2];
$job =~ s/--video=// ;
my $q_num=$job % 7;

use File::Basename;
my $dirname = dirname(__FILE__);
my $configFile = "$dirname/config.config";

my $config = Config::Tiny->read( $configFile );
my $daemonpath = $config->{_}->{daemonpath};

# Set path to queue
my $q_file="$daemonpath/$q_num";

print "Piping new encode into the queue at $q_file...\n";
my $q = new File::Queue (File => $q_file,Mode=>0774 );

my $command=join(' ',@ARGV);
print "Job $job Q $q_num\n";
print "command $command \n";
$q->enq($command);
exit;

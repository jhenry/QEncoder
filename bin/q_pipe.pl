#!/usr/bin/perl
use strict; 
use File::Queue;
use Config::Tiny;
my $job=$ARGV[2];
$job =~ s/--video=// ;
my $q_num=$job % 7;

my $Config = Config::Tiny->new;
$Config = Config::Tiny->read( 'config.config' );
my daemonpath = $Config->{_}->{daemonpath};

# Set path to queue
my $q_file="$daemonpath/$q_num";

my $q = new File::Queue (File => $q_file,Mode=>0774 );
my $command=join(' ',@ARGV);
print "Job $job Q $q_num\n";
print "command $command \n";
$q->enq($command);
exit;

#!/usr/bin/perl
use strict;
use warnings;

if (scalar @ARGV != 1) {
	print "running with ubuntu-CPU-frequency_limiter.pl -max/-min \n";
	exit;
}

my $mode = $ARGV[0];
my $path_to_cpus = "/sys/devices/system/cpu";
my @cpus = `readlink -f $path_to_cpus/cpu*/cpufreq/scaling_available_frequencies`; chomp @cpus;
my $num_cpus = scalar @cpus;

print "Found $num_cpus cpus\n";

foreach my $cpu (@cpus) {
	print "Handling $cpu\n";
	my $set_path = $cpu;
	$set_path =~ s/scaling_available_frequencies/scaling_max_freq/g;
	my @avalible_speeds = `cat $cpu | sed \'s/ /\\n/g\' | sort -n | grep .`; chomp @avalible_speeds;
	if(scalar @avalible_speeds == 0) {
		continue;
	}
	my $min = $avalible_speeds[0];
	my $max = $avalible_speeds[-1];
	print "min: $min max: $max\n";
	print "Writing to $set_path\n";
	if ($mode eq "-max") {
		`echo $max > $set_path`;
	} elsif ($mode eq "-min") {
		`echo $min > $set_path`;
	} else {
		print "Error: unknown mode: $mode\n";
		exit;
	}
}

#!/usr/bin/env perl

use LWP::Simple;

my $face, $style, $weight, $name1, $name2, $format, $url;
my $block = 0;

print "face\tstyle\tweight\tname\tsname\tformat\turl\n";
while (<>) {
	if (/^\@font-face\ \{$/) {
		$face = $style = $weight = $name1 = $name2 = $url = $format = "";
		$block = 1;
	}
	elsif (/font-family: '([\w\ ]+)';/) {
		$face = $1;
	}
	elsif (/font-style: (\w+);/) {
		$style = $1;
	}
	elsif (/font-weight: (\d+);/) {
		$weight = $1;
	}
	elsif (/src: local\('([\w\W]+)'\), local\('([\w\-]+)'\), url\(([\w\:\/\-\.]+)\) format\(\'(\w+)\'\);/) {
		$name1 = $1;
		$name2 = $2;
		$url = $3;
		$format = $4;
	}
	elsif (/^\}$/) {
		if (!$block) {
			die "Data without block!";
		}
		$block = 0;
		print "$face\t$style\t$weight\t$name1\t$name2\t$format\t$url\n";
		my $dname = $face;
		$dname =~ s/\W//g;
		$dname = lc($dname);
		my $path = $dname;
		my $fname = "$path/$style-$weight.$format";
		mkdir("$path");
		my $status = getstore($url, $fname);
		if (is_error($status)) {
			print STDERR "Failed to download $url to $fname\n";
		}
#		else {
#			print STDERR "Downloaded $url to $fname\n";
#		}
	}
}

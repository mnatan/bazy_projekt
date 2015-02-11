#!/usr/bin/perl
#
# All credits to https://github.com/s-nez
#
use strict;
use warnings;
use feature 'say';

sub reset_filehandle {
	seek $_[0], 0, 0;
}

# Returns real word length taking special characters into account
sub unicode_length {
	my $tmp = $_[0];
	my $u_length = $tmp =~ s/\p{InLatin-1_Supplement}//g;
	return (length $tmp) + ($u_length/2);
}

# $_[0] - string to space, $_[1] - spacing size
sub spacing {
	return '' unless defined $_[0];
	my $padding = 0;
	$padding = ($_[1] - unicode_length $_[0]) if defined $_[1];
	return $_[0] . ' ' x $padding;
}

# Prints a line of '-' characters separated by '+', arguments specify lengths
sub separator {
	my $result = '';
	foreach (@_) {
		$result .= '+';
		$result .= '-' x $_;
	}
	return $result . "+\n";
}

@ARGV or die "No arguments";
open my $FILE, $ARGV[0] or die "$ARGV[0]:$!";

my @header = split "\t", <$FILE>;
my @max_lengths;
foreach (0 .. $#header) {
	chomp $header[$_];
	$max_lengths[$_] = unicode_length $header[$_];
}
while (<$FILE>) {
	chomp;
	my @line = split "\t", $_;
	foreach (0 .. $#line) {
		my $cur_length = unicode_length $line[$_];
		if ($cur_length > $max_lengths[$_]) {
			$max_lengths[$_] = $cur_length;
		}
	}
}

my @borders;
foreach (0 .. $#max_lengths) {
	$borders[$_] = $max_lengths[$_] + 2;
}

# Print out the header
print separator @borders;
reset_filehandle $FILE;
<$FILE>;
my $column_count = 0;
foreach (0 .. $#header) {
	chomp $header[$_];
	print '| ', spacing $header[$_], $max_lengths[$_] + 1;
	++$column_count;
}
print "|\n";


# Print out the remaining part of the table
print separator @borders;
my $row_count = 0;
while (<$FILE>) {
	chomp;
	my @line = split "\t", $_;
	foreach (0 .. $#line) {
		$line[$_] = 'NULL' if $line[$_] eq '\0';
		print '| ', spacing $line[$_], $max_lengths[$_] + 1;
	}
	++$row_count;
	print "|\n"
}
print separator @borders;
print ">>>>>> Łącznie: $row_count wierszy, $column_count kolumn\n";

close $FILE;

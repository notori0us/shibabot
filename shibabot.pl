#!/usr/bin/perl -w
use warnings;
use strict;

package ShibaBot;
use base qw( Bot::BasicBot );

# path to thesaurus
# 	expected to be word,synonym1,synonym2,...,synonymn,
my $path_to_thesaurus = "./thesaurus";

my @channels = ['#osuosc','#think', '#r/linux', '#twitchplayspokemon'];

# said callback
sub said {
	my ($self, $message) = @_;

	if ($message->{body} =~ /^\.doge\b/) {
		my $text = $message->{body};
		$text =~ s/^\.doge\ //;

		(my $word) = $text=~/(\w+)/;


		# read through thesaurus to find synonyms
		open( THESAURUS, "<", $path_to_thesaurus )
			or die "couldn't open thesaurus file";

		while(<THESAURUS>) {
			chomp;
			next unless /^$word,/;
			last;
		}

		close (THESAURUS);

		# split what we just got into a list of synonyms
		# 	then pick random ones
		my @synonyms = split(',', $_);

		my $size = scalar @synonyms;

		if ($size > 0){

			my $index = int(rand($size));
			if ($index == 0) {
				$index = 1;
			}

			my $spaces;
			for (my $i = 0; $i <= int(rand(20)); $i++) {
				$spaces = $spaces . " "
			}

			$self->say(
				channel => $message->{channel},
				body =>  $spaces . "such " . $word,
			);

			$spaces = "";
			for (my $i = 0; $i <= int(rand(20)); $i++) {
				$spaces = $spaces . " "
			}

			$self->say(
				channel => $message->{channel},
				body => $spaces . "so " . $synonyms[$index],
			);

			$spaces = "";
			for (my $i = 0; $i <= int(rand(20)); $i++) {
				$spaces = $spaces . " "
			}

			$self->say(
				channel => $message->{channel},
				body => $spaces . "wow",
			);

			$spaces = "";
			for (my $i = 0; $i <= int(rand(20)); $i++) {
				$spaces = $spaces . " "
			}

			$self->say(
				channel => $message->{channel},
				body => $spaces . "much " . $synonyms[$index],
			);


		}

		return;
	}
}
ShibaBot->new(
	server => 'irc.freenode.net',
	channels => @channels,
	nick => 'shibabot',
)->run();

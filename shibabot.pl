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


		# Generate spaces
		sub generate_spaces {

			my $spaces;
			$spaces = "";
			for (my $i = 0; $i <= int(rand(25)); $i++) {
				$spaces = $spaces . " "
			}

			return $spaces;

		}

		# split what we just got into a list of synonyms
		# 	then pick random ones
		my @synonyms = split(',', $_);

		my $size = scalar @synonyms;

		my @response_words = ("such","much");

		if ($size > 0){

			my $index = int(rand($size));
			if ($index == 0) {
				$index = 1;
			}

			$self->say(
				channel => $message->{channel},
				body => generate_spaces() . $response_words[rand @response_words]. " " . $word,
			);

			$self->say(
				channel => $message->{channel},
				body => generate_spaces() . "so " . $synonyms[$index],
			);

			$self->say(
				channel => $message->{channel},
				body => generate_spaces() . "wow",
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

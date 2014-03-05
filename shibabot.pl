#!/usr/bin/perl -w
use warnings;
use strict;

package ShibaBot;
use base qw( Bot::BasicBot );

# CONFIGURIGATION
# --------------------------------------------------

# path to thesaurus
# 	expected to be word,synonym1,synonym2,...,synonymn,
my $path_to_thesaurus = "./thesaurus";

my $nick = "shibabot";
my $server = "chat.freenode.net";
my @channels = ['#osuosc','#think', '#r/linux'];

#possible responses
my @doge = ("so", "much", "very");

# begin

# said callback
sub said {
	my ($self, $message) = @_;

	if ($message->{body} =~ /^\.doge\b/) {
		my $text = $message->{body};
		$text =~ s/^\.doge\ //;

		(my $word) = $text=~/(\w+)/;
		# lowercase input
		$word = lc($word);


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

		if ($size > 0){

			my $index = int(rand($size));
			if ($index == 0) {
				$index = 1;
			}

			$self->say(
				channel => $message->{channel},
				body => generate_spaces() . "such " . $word,
			);

			$self->say(
				channel => $message->{channel},
				body => generate_spaces() . $doge[rand @doge] . " " . $synonyms[$index],
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
	server => $server,
	channels => @channels,
	nick => $nick,
)->run();

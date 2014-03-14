#!/usr/bin/perl -w
use warnings;
use strict;

# shibabot, such bot very wow
# Copyright (C) 2014 Chris Wallace (notori0us) <wallace.586@osu.edu>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

package ShibaBot;
use base qw( Bot::BasicBot );

# CONFIGURIGATION
# --------------------------------------------------

# path to thesaurus
# 	expected to be word,synonym1,synonym2,...,synonymn,
my $path_to_thesaurus = "./thesaurus";

# such details
my $nick = "shibabot";
my $server = "chat.freenode.net";
my @channels = ['#osuosc','#think', '#r/linux', '#ncsulug'];
# wow

# possible response prefixes
my @doge = ("so", "much", "very");

# CODE
# --------------------------------------------------

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

# SHIBE
# --------------------------------------------------

ShibaBot->new(
	server => $server,
	channels => @channels,
	nick => $nick,
)->run();

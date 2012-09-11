#!/bin/zsh
# post to tumblr using api v2 and OAuth
#
# From:	Timothy J. Luoma
# Mail:	luomat at gmail dot com
# Date:	2012-09-07

	# You MUST change the next few lines

	# What is the tumblr name you want to post to?
BLOG_HOSTNAME='soundofthebeep.tumblr.com'

	# Where did you save the curlicue information?
CURLICUE="$HOME/.curlicue-oauth-for-my-tumblr-app.txt"

	# where did you save the sed file?
SEDFILE="$HOME/urlencode-sed.txt"


####|####|####|####|####|####|####|####|####|####|####|####|####|####|####
#
#	You should not change anything under here unless you know what you're
#	doing and why.
#


	# text, photo, quote, link, chat, audio, or video
TYPE=text

	# use Markdown whenever possible. It's a lot easier than HTML.
FORMAT=markdown

	# The first 'word' (or multiple words, if enclosed in quotes' will be the Title
	# everything after that will be the body
TITLE_RAW="$1"

	# shift over so we get the rest of the arguments for the body
shift

	# NOTE: Technically the title CAN be empty, but the body CANNOT.
BODY_RAW="$@"

	# now we transform the 'raw' values (which the user gave us) into the URL-encoded values

BODY=$(echo -n "$BODY_RAW" | sed -f "$SEDFILE")

TITLE=$(echo -n "$TITLE_RAW" | sed -f "$SEDFILE")

	# Now we call curlicue with the OAuth information we saved in a file just for it
	# and we send the rest of the information to curl
curlicue -f "$CURLICUE" \
-- -d "format=$FORMAT&type=TYPE&title=$TITLE&body=$BODY" "http://api.tumblr.com/v2/blog/$BLOG_HOSTNAME/post"

exit 0


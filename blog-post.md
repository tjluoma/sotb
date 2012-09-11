Date: 2012-09-11
Title: Posting to Tumblr using curl and OAuth
Slug: tumblr-oauth-and-curl
Description: 
Tags: curl,tumblr
Author: TJ Luoma
Affiliation: http://luo.ma/
Copyright:  Timothy J. Luoma
CSS: notes.css


# Posting to Tumblr using curl and OAuth #

As of the first week in September 2012, posting to Tumblr via curl (and the version 1 of Tumblr's API) stopped working. Anyone who wants to post now must use OAuth.

It *is* possible to post to Tumblr with `curl` using OAuth, but it's ugly. Currently, in fact, it's *really* ugly. Hopefully it will get better in time, and if so, I will either try to write up or link to better directions. These instructions were first written in the wee small hours of 2012-09-11.

Before I begin, I want to give a huge thank you to [David (aka "dig-the-cat")](http://dig-the-cat.com) who figured out an essential part of this. Without his help I don't think I would have been able to do it.

## Step 1: Register an app with Tumblr

This is the easiest step.

After reading the [Application Developer and API License Agreement](http://www.tumblr.com/policy/en/api), head over to the [API v2 documentation](http://www.tumblr.com/docs/en/api/v2).

From there you will find a link to <http://www.tumblr.com/oauth/apps> which is where you go to register an application (or to see applications that you have already registered).

Fill out the form at <http://www.tumblr.com/oauth/register>.

*Make sure that your name doesn't sound anything like "Tumblr" (that's in the API license agreement that you read).*

You will need to provide a "callback URL." Basically this can be any web page you have control over. But remember it, we'll need it later.

Note that the 'icon' is particularly important because it is what people will see when they are asked to authenticate your app, as well as what you will see when looking through your list of apps. I chose to use my Twitter "avatar" because I figured that most people would recognize that and associate it with me. 

Currently the image must be a 128x128 PNG.

As soon as you finish registering an application, your "OAuth Consumer Key" and "Secret Key" will be available on the <http://www.tumblr.com/oauth/apps> page.

Make a note of those, you will need them.

I'm going to use "Wharrrbl" as my example "Consumer Key" and "PERPERDERG" as my example "Secret Key, but course these are really long strings of numbers and letters.

## Step 2: Get your OAuth 'tokens'

Here's where things start to get 'fun'.

A) Download <https://gist.github.com/2603387> and save it as `callback.py`. 

*Note:* that the owner of that gist is [John Bunting](https://github.com/codingjester) who works at Tumblr, and who tried his best to help me understand this process. He also seems to have done a lot of work making Tumblr accessible via ruby, python, etc. Seems like an all around good guy.

B) Note that in order to get `callback.py` to work, I can to install the OAuth2 libraries for Python. On my Mac (10.8) that was as simple as issuing this command in Terminal:

	sudo easy_install oauth2

C) Near the top of `callback.py` you'll see two lines which look like this:

	consumer_key = 'xxiWjWYQg3EV7XGfIxavHzkxgsHHcjHFy3dWUAbWdURlIEdPlF'
	consumer_secret = '0XLRxlMfA3VGg4GfVSUpmPJHJv8IF1NGp71mc5uqfsBO34RLeS' 

You must change those two lines to be the values that for your app that you got at the end of step 1.

You will also see a line which includes a reference to **"http://localhost/doctorstrange"**. You need to change that URL to be your "callback URL" from earlier.

D) Once you have all of that in place, you need to call `callback.py` like this:

	python /path/to/callback.py

and you will see something like this:

	Request Token:
	    - oauth_token        = foo
	    - oauth_token_secret = bar
	
	Go to the following link in your browser:
	http://www.tumblr.com/oauth/authorize?oauth_token=foo&oauth_callback=http%3A%2F%2Fyour.domain.here%2Fyourcallbackpage.tld
	
Of course 'foo' and 'bar' are actually very very very long strings of letters and numbers. I just said 'foo' and 'bar' for brevity.

The important thing here is to copy/paste the URL which appears after "Go to the following link in your browser".

When you do that, you'll see something like this:

![Example OAuth authorization page](http://images.luo.ma/Tumblr-OAuth-20120911.jpg)

I added the yellow line to use as a reference point.

Everything *above* the yellow line refers to which Tumblr account you will be posting *to*. So you ought to see your Tumblr icon, your Tumblr name, and your Tumblr URL (or custom domain, if you have one).

Everything *below* the yellow line refers to the script/app/program/whatever which wants to be able to read and write to the account listed *above* the yellow line.

The icon of my face is the one that I uploaded in step 1. The github URL is the URL that I put in when I registed my app (*NOT* the callback URL). And "sotb.sh" is the name of the program.

*Note:* When you approve an app to have read and write access to your account, it will be able to read and write to *every* Tumblr site associated with that account. So if you have a dozen "sub-Tumblrs" associated with your Tumblr account, you only need to authorize each app one time. *However* if you have separate *login* accounts for Tumblr (a different email address and password) then you will need to repeat this part of the process for each one.

Click "Allow" and ***don't panic when you get a 404 page.***

## Step 3: Tumblr and the "WTFOMG" URL

Once you click "Allow" in step 2, you will be redirected to a new URL at Tumblr.com which begins with **http://tumblr.com/omgwtf**

That page will show a 404 'not found' error on Tumblr.

The **bad news** is that I have no idea why this happens. I *think* that 'callback.py' is using an outdated URL for Tumblr (you can see 'omgwtf' in the source if you look).

The **good news** is that the 404 page *actually* gives you what you need. Go up into the address bar and copy and paste the entire URL, which will look something like this:

	http://www.tumblr.com/omgwtf?oauth_token=qPPIoYGU4XJ5unZ6Rwj2TbXd0ipD1&oauth_verifier=uDYK8mG3ZgTOKnQzJIIkLL0Xcau2P3dn4

Save that to a text file somewhere for a moment.

See that part after 'oauth_verifier'? That's what you need.

Go back to the Terminal window (from Step 2) where you were given the URL and the instructions "Go to the following link in your browser" and you will see a prompt:

	Have you authorized me? (y/n) 
	
Press <kbd>Enter</kbd> and you will be asked:

	What is the OAuth Verifier? 
	
Paste the OAuth Verifier part of the URL (in my fake example above that would be "uDYK8mG3ZgTOKnQzJIIkLL0Xcau2P3dn4") WITHOUT ANYTHING ELSE.

Then press <kbd>Enter</kbd> again and you will see

	Access Token:
	    - oauth_token        = abc1234
	    - oauth_token_secret = defgh09876
	
	You may now access protected resources using the access tokens above.
	
Of course the actual 'oauth_token' and 'oauth_token_secret' are much longer.  Make a note of them, you will need those later.

## Step 4: Enter curlicue

> [Curlicue](https://github.com/decklin/curlicue) 
> is a small wrapper script that invokes curl with the necessary
> headers for OAuth. It should run on any POSIX-compatible shell. 

curlicue is a great and powerful program.

I don't really understand how it works. I tried to get it to give me the information that I needed, but I couldn't get it to work. Finally David/dig-the-cat stepped in and figured out the syntax for the file that `curlicue` will create on its own if you used it instead of `callback.py` **but I was not able to get it to work instead of callback.py**.

I don't know if I was doing something wrong or if Tumblr's API does something different, and after a certain point I didn't care anymore, I just wanted to get it to work.

To start with, create a text file that looks like this:

	oauth_consumer_key=
	oauth_consumer_secret=
	oauth_token=
	oauth_token_secret=

Now you need to copy/paste the correct information into each one of those fields.

The first two are specific to your application, you can get them at <http://www.tumblr.com/oauth/apps> anytime.

The second two are specific to a particular Tumblr account, and will be different every time.

You will remember that I used "Wharrrbl" and "PERPERDERG" for my 'consumer' tokens, now I am going to add those to the file, so it will look like this:

	oauth_consumer_key=Wharrrbl
	oauth_consumer_secret=PERPERDERG
	oauth_token=
	oauth_token_secret=

now I'm going to take the 'oauth_token' and the 'oauth_token_secret' from Step 3, and put them in the file also:

	oauth_consumer_key=Wharrrbl
	oauth_consumer_secret=PERPERDERG
	oauth_token=abc1234
	oauth_token_secret=defgh09876

Note that each of those 4 example values has been *vastly* simplified. In reality they are obnoxiously long strings of letters and numbers.

Once you have those in the proper place, replace each new-line/end-of-line character with a `&` EXCEPT for the last one. So now it should look like this:

	oauth_consumer_key=Wharrrbl&oauth_consumer_secret=PERPERDERG&oauth_token=abc1234&oauth_token_secret=defgh09876

Note that there should be three `&` not four, and there should *not* be one at the beginning or end of the line.

What you should have is ***one long line*** in a plain text file.

***There must not be anything else in that file.***

Save this file as something memorable, like '~/.curlicue-oauth-for-my-tumblr-app.txt'

(Take a deep breath, you are almost there.)

Now, download [curlicue](https://github.com/decklin/curlicue/blob/master/curlicue) and save it somewhere in your $PATH like /usr/local/bin/curlicue and make sure it is executable:

	chmod 755 /usr/local/bin/curlicue
	
## Step 5: Try a test post

First, a warning: the Tumblr API is *extremely* finicky and terse. If you get anything wrong, even the slightest syntax error, you will get a a '401 not authorized' error.

Do not expect any help whatsoever from the API error codes or responses. It's all or nothing. Either it works (which will give you a 'created' message) or it won't (401 not authorized).

Now you are ready. Copy/paste this command **being sure to change 'EXAMPLE' to the name of whatever Tumblr you are trying to post to.** For example, if your Tumblr URL is <http://beefranck.tumblr.com> then change EXAMPLE to 'beefranck'.

	curlicue -f ~/.curlicue-oauth-for-my-tumblr-app.txt \
	-- -d 'type=text&title=TestTitle&body=TestBody' \
	'http://api.tumblr.com/v2/blog/EXAMPLE.tumblr.com/post'

If you see

	{"meta":{"status":401,"msg":"Not Authorized"},"response":[]}%

it failed.

If you see 

	{"meta":{"status":201,"msg":"Created"},"response":{"id":8675309}}

then it worked. (Note that the 'id' value will change for each post.)

## Step 6: Just when you thought you were done…

You're not done.

Yes, if all has gone well up to this point, you can now post to Tumblr from the command line…

…as long as you are OK just posting single words for the Subject and Body.

However, if you want to use things like *spaces* or *punctuation* then you need to do a little more work because those values have to be "URL Encoded."

You could [read the RFC](http://www.ietf.org/rfc/rfc1738.txt) but instead I recommend checking out <http://www.freeformatter.com/url-encoder.html> which will make it easy to find the proper encoding values.

There are a variety of ways of dealing with this, but my preference is to stick them all in a file that I can use whenever I need to URL-encode something, and then do it with [sed](http://www.grymoire.com/Unix/Sed.html). Others may prefer perl or some other solution, but sed works fine.

The easiest way to do this is setup a substitutions file for sed. For example, this [gist](https://gist.github.com/3696160) shows my sed file:

<script src="https://gist.github.com/3696160.js?file=urlencode-sed.txt"></script>

Save it as **urlencode-sed.txt** (or whatever) and call it like this:

	echo 'Hello World!' | sed -f ~/urlencode-sed.txt
	
and you will get back
	
	Hello%20World%21
	
Both the Title and the Body have to be URL encoded.	
**It would be annoying to keep having to do this manually,** so I made a simple zsh shell script to make all of these pieces work together *once you have done the initial configuration.*

You can find it at <https://github.com/tjluoma/sotb>, specifically <https://github.com/tjluoma/sotb/blob/master/sotb.sh>.

Basically all you have to do is edit a few lines in that file to tell it what Tumblr site you want to post to, and then tell it where your curlicue file is (~/.curlicue-oauth-for-my-tumblr-app.txt or somewhere else) and where your sed file is (~/urlencode-sed.txt or somewhere else).

## Step 7: Accept the limitations of the present reality

This process is not beautiful. It's ugly. It's convoluted and overly complicated. Hopefully someone else is already working on a better way.

But until then, this is what I've patched together. I hope it will be useful for others who are stuck in the same situation. Maybe one of you will build the better solution that I'll use tomorrow.








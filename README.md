### Example Application that uses Bing Translate Text To Speech

The [Bing Translation API](http://www.microsoft.com/en-us/translator/developers.aspx) includes a Text To Speech (TTS) feature which is useful for many applications other than language translation.

At the time of writing, this seems to be the best free Text To Speech API available. Google has one linked to its translation API but it is not actively supported and there are several commercial TTS services. A very nice feature of the Bing API is the ability to specify the language, which greatly improves the quality of the speech.

This Git repository contains a basic Ruby [Sinatra](http://www.sinatrarb.com/) application that accesses this API through the ruby gem [bing_translator](https://github.com/CodeBlock/bing_translator-gem), written by Ricky Elrod.


The demo consists of the basic Sinatra app and two web pages. These implement two approaches to the problem.

The first approach, in index.html, uses the Web Audio API to handle the audio data directly. The second, in text_to_speech_audio_tag.html, uses the &lt;audio&gt; tag to play an audio file that is downloaded from Amazon AWS S3 via a proxy on your server.

The second approach is a lot more complex than the first, however this does work with Firefox which does not currently have the Web Audio API implemented.

###Web Audio API approach

Text entered in the web page is sent to the Sinatra app via Ajax. The server forwards the text to the Bing Translate API, which returns the spoken text as binary data in WAV format to the browser. The audio is stored in memory in the browser and can be played multiple times without reloading. Amazon AWS S3 is not involved in this approach at all.

###Audio Tag approach

In the absence of the Web Audio API, the server writes the audio from Bing to a file on Amazon AWS and returns the filename of this to the client. To play the audio the client uses the &lt;audio&gt; tag to download the audio file from S3 via a proxy on your server.

This setup is somewhat involved and you should have some experience with Sinatra and Amazon AWS S3 before you undertake this. There are plenty of resources out there to help you with that.


###Live demo:

A live version of the tutorial is at [http://bing-translate-tts-demo.craic.com](http://bing-translate-tts-demo.craic.com) - you should give that a try first see what the working app looks like.


###Set up

In order for the demo to work you need :

1: A server on which to run the application file - you might want to set it up as an app on [Heroku](http://heroku.com)

2: Bing Translate credentials - see the [Bing developer site](https://datamarket.azure.com/dataset/1899a118-d202-492c-aa16-ba21c33c06cb) - the site is not very clear, you might need to dig around. Sign up for the Free level (up to 2 million chars / month)

3: Amazon AWS credentials - see [Amazon AWS](http://aws.amazon.com/) - They have a free tier of service as well

Enter the server address in public/index.html and the bing and AWS credentials in html5_app.rb


Amazon S3:

You should create a bucket to hold the audio files. The Sinatra script will create files that can be read by anyone. You might also want to add a bucket lifecycle policy the removes audio files after one day. That way they don't accumulate.

Sinatra:

Run 'bundle install' to install the required gems before starting up the server. You can do basic testing locally by starting the server with 'rackup -p 4567' and then browsing to 'http://localhost:4567'. But NOTE that the application must run on a remote server in order for audio files to play correctly.

Refer to the heroku documentation to get it started on that service.

Troubleshooting:

The demo has a lot of moving parts - add/uncomment debugging statements in the web page (console.log) and Sinatra code (STDERR.puts) to help if you run into problems.


The demo is written by Robert Jones of [Craic Computing](http://craic.com) and is freely distributed under the terms of the MIT license.


Gotchas:

The original code ran fine on Google Chrome but Firefox turned up some <a href="http://craiccomputing.blogspot.com/2013/04/gotchas-when-working-with-htm5-audio.html">Gotchas</a>. I had to switch to .wav files instead of .mp3 as Firefox will not play MP3 files and I had to proxy the audio files through my server instead of playing them directly as AWS S3 does not support the Access-Control-Allow-Origin header for files.




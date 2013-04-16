#!/usr/bin/env ruby

# html5_app.rb

# Copyright 2013 Robert Jones  (jones@craic.com)   Craic Computing LLC
# This code and associated data files are distributed freely under the terms of the MIT license

require 'open-uri'
require 'base64'
require 'json'

require 'aws-sdk'

require 'bing_translator'

$:.unshift File.join(File.dirname(__FILE__))

class Html5App < Sinatra::Base

  set :root, File.dirname(__FILE__)

  set :static, true

  # Set up AWS and Bing credentials  --- DO NOT MAKE THESE AVAILABLE TO OTHERS

  aws_access_key_id     = "YOUR KEY GOES HERE"
  aws_secret_access_key = "YOUR KEY GOES HERE"
  aws_s3_bucket         =  "YOUR S3 BUCKET GOES HERE"

  bing_client_id     = "YOUR BING CLIENT ID GOES HERE"
  bing_client_secret = "YOUR BING CLIENT SECRET GOES HERE"

  AWS.config({"access_key_id" => aws_access_key_id, "secret_access_key" => aws_secret_access_key})

  s3 = AWS::S3.new
  bucket = s3.buckets[aws_s3_bucket]

  get '/' do
    File.read(File.join('public', 'index.html'))
  end

  get '/text_to_speech' do

    query = params['query']
    language = params['language']

    translator = BingTranslator.new(bing_client_id, bing_client_secret)

    # Fetch the MP3 audio for this phrase
    audio_stream = translator.speak query, :language => language, :format => 'audio/mp3', :options => 'MaxQuality'

    # create a unique digest with the text query and the current time
    digest = Digest::SHA1.hexdigest "#{query} #{Time.now.to_s}"

    # Write to a file on Amazon S3
    filename = "#{language}_#{digest}.mp3"

    s3obj = bucket.objects[filename].write(audio_stream, :acl => :public_read)

    # return the url as json

    response["Access-Control-Allow-Origin"] = "*"
    content_type 'application/json', :charset => 'utf-8'
    { 'url' => s3obj.public_url }.to_json
  end

end
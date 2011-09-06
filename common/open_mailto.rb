#!/usr/bin/env ruby
# see http://www.howtogeek.com/howto/ubuntu/set-gmail-as-default-mail-client-in-ubuntu/

gmail_args = ARGV[0].dup
gmail_args.gsub!(/^mailto:/, '&to=')
gmail_args.gsub!(/[?&]subject=/, '&su=')
gmail_args.gsub!(/[?&]cc=/, '&cc=')
gmail_args.gsub!(/[?&]bcc=/, '&bcc=')
gmail_args.gsub!(/[?&]body=/, '&body=')

system("firefox -remote 'openurl(https://mail.google.com/mail?view=cm&tf=0#{gmail_args},new-tab)'")

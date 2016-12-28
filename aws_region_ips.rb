#!/usr/bin/env ruby
require 'open-uri'
require 'json'

IP_RANGES_URL = 'https://ip-ranges.amazonaws.com/ip-ranges.json'.freeze

begin
  open(IP_RANGES_URL) do |f|
    json = JSON.parse(f.read)
    json['prefixes'].each do |prefix|
      puts prefix['ip_prefix'] if prefix['region'] == ARGV[0]
    end
  end
rescue OpenURI::HTTPError => err
  STDERR.puts("Unable to open document at #{IP_RANGES_URL} (#{err})")
  exit(1)
end

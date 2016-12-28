#!/usr/bin/env ruby
require 'open-uri'
require 'json'

IP_RANGES_URL = 'https://ip-ranges.amazonaws.com/ip-ranges.json'.freeze
USAGE_TEXT    = 'Usage: aws_regions_ips.rb <region>'.freeze

abort USAGE_TEXT if ARGV.length.zero?

if ARGV[0] == '--help'
  puts USAGE_TEXT
  exit
end

begin
  open(IP_RANGES_URL) do |f|
    json = JSON.parse(f.read)
    json['prefixes'].each do |prefix|
      puts prefix['ip_prefix'] if prefix['region'] == ARGV[0]
    end
  end
rescue OpenURI::HTTPError => err
  abort "Unable to open document at #{IP_RANGES_URL} (#{err})"
end

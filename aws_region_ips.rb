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
  region = ARGV[0]
  ip_addresses = []
  
  open(IP_RANGES_URL) do |f|
    json = JSON.parse(f.read)
    json['prefixes'].each do |prefix|
      ip_addresses << prefix['ip_prefix'] if prefix['region'] == region
    end
    
    abort "No IP addresses for region '#{region}'" if ip_addresses.empty?    
    ip_addresses.each { |ip_address| puts ip_address }
  end
rescue OpenURI::HTTPError => err
  abort "Unable to open document at #{IP_RANGES_URL} (#{err})"
end

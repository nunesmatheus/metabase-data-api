require 'bundler/setup'
require 'nokogiri'

File.open('public/coverage/index.html') do |f|
  doc = Nokogiri::HTML(f)
  coverage = doc.css('.covered_percent span').first.text.strip.sub('%', '')
  puts coverage
end

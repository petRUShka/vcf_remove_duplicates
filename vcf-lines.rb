#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'

$-w = true
$:.unshift File.dirname($0) + '/../lib'

require 'pry-byebug'
require 'pp'
require 'getoptlong'
require 'vpim/vcard'

HELP =<<EOF
Usage: #{$0} <vcard>...

Options
  -h,--help      Print this helpful message.

Examples:
EOF

opt_name  = nil
opt_debug = nil

opts = GetoptLong.new(
  [ "--help",    "-h",              GetoptLong::NO_ARGUMENT ],
  [ "--name",    "-n",              GetoptLong::NO_ARGUMENT ],
  [ "--debug",   "-d",              GetoptLong::NO_ARGUMENT ]
)

opts.each do |opt, arg|
  case opt
    when "--help" then
      puts HELP
      exit 0

    when "--name" then
      opt_name = true

    when "--debug" then
      opt_debug = true
  end
end

if ARGV.length < 1
  puts "no vcard files specified, try -h!"
  exit 1
end

ARGV.each do |file|
  cards = Vpim::Vcard.decode(open(file))

  new_cards = cards.each_with_index.find_all do |card, index| 
    card.telephones.size != 1 or
      cards[0, index].index {|el| el.telephone == card.telephone }
  end

  new_cards.each { |card| puts card.first.to_s }
end


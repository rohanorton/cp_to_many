#!/usr/bin/env ruby
require "fileutils"
require "optparse"

options = {}

OptionParser.new do|opts|
    opts.banner = "Usage: cp_to_many.rb [OPTION]... SOURCE DEST...\nCopy SOURCE to multiple DEST(s).\n\n"
    
    opts.on("-v", "--verbose", "Run verbosely") do |v|
        options[:verbose] = v
    end

    opts.on("-p", "--preserve", "Preserve mode, ownership, timestamps") do |p|
        options[:preserve] = p
    end

    opts.on("-d", "--dry-run", "No changes made") do |d|
        options[:noop] = d
    end

    opts.on('-h', '--help', 'Displays this help message') do
        puts opts
        exit
    end
end.parse!

src = ARGV.shift()
dests = ARGV


for dest in dests
    # TODO:
    # need to assess dests to see if it contains special characters
    # should probably accept something like...
    #   my_dir/[name1,name2].ext
    # which we can parse out
  FileUtils.cp(src, dest, options)
end    

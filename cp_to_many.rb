#!/usr/bin/env ruby
require "fileutils"

src = ARGV.shift()
dests = ARGV


for dest in dests
  puts "cp -r '#{src}' '#{dest}'"
  FileUtils.cp_r(src, dest)
end    

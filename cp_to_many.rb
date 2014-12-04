#!/usr/bin/env ruby
require "fileutils"
require "optparse"

def die(error_type, src = nil)
    get_help = "\nTry '#{$PROGRAM_NAME} --help' for more information"
    error_message = {
        :no_src => "missing file operand #{get_help}",
        :cannot_stat => "cannot stat '#{src}': no suce file or directory",
        :no_dest => "missing destination file operand after '#{src}' #{get_help}"
    }
    puts "#{$PROGRAM_NAME}: #{error_message[error_type]}"
    exit 1
end

options = {}
cp_options = {}

OptionParser.new do|opts|
    opts.banner = "Usage: #{$PROGRAM_NAME} [OPTION]... SOURCE DEST...\nCopy SOURCE to multiple DEST(s).\n\n"
    
    opts.on("-v", "--verbose", "Run verbosely") do |v|
        cp_options[:verbose] = v
    end

    opts.on("-r", "--recursive", "Run recursively") do |r|
        options[:recursive] = r
    end

    opts.on("-p", "--preserve", "Preserve mode, ownership, timestamps") do |p|
        cp_options[:preserve] = p
    end

    opts.on("-d", "--dry-run", "No changes made") do |d|
        cp_options[:noop] = d
    end

    opts.on('-h', '--help', 'Displays this help message') do
        puts opts
        exit
    end
end.parse!

src = ARGV.shift()
if !src then  die(:no_src) end

dests = ARGV
if dests.length == 0 then die(:no_dest, src) end

begin 
    File.stat(src)
rescue
    die(:cannot_stat, src)
end

for dest in dests
    # assess dests to see if it contains special characters
    # should accept something like...
    #   my_dir/[[name1,name2]].ext

    if dest.include? "[[" and dest.include? "]]" 
        ## firstly... remove the matching text from the dest array
        dests.delete(dest)

        ## get inner and outer strings
        outer_left_string, dest = dest.split("[[")
        inner_string,outer_right_string = dest.split("]]")
        
        split_string = inner_string.split(",")

        for i in split_string 
            filename = "#{outer_left_string}#{i}#{outer_right_string}"
            dests.push(filename)
        end
    end
end

for dest in dests
    if options[:recursive]
        FileUtils.cp_r(src, dest, cp_options)
    else
        FileUtils.cp(src, dest, cp_options)
    end
end    

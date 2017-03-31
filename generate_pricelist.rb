#!/usr/bin/env ruby

require 'csv'
require 'awesome_print'

def style
  <<-EOM
  <style type="text/css">
    * { font-family: Helvetica, sans-serif; font-size: 11px; }
    h2 { font-size: 2rem; padding: 10px 30px 0; }
    .byline { font-size: 1.4rem; padding: 0 30px 10px; }
    .byline { font-style: italic; }
    .entry { position: relative; float: left; width: 155px; border-top: 1px solid #ddd; padding: 30px; min-height: 120px;}
    .entry-item { text-align: right; text-transform: capitalize; line-height: 1.4em; }
    .entry-number { float: left; font-weight: bold; font-size: 1.1em; line-height: 1.4em;}
    .name { font-weight: bold; font-size: 1.1em; }
    .medium { font-style: italic; }
    .contact { float: right; padding-top: 10px;padding-right: 50px; text-align: right; }    
    @media print {
    .page-break {
       page-break-after: always;
    }
    }
  </style>
  EOM
end

def header
  <<-EOM
    <div class='contact'>
      e: mrrogers@bunnymatic.com
      <br/>
      tweet: @bunnymaticsf
      <br/>
      instagram: @bunnymaticsf
      <br/>
      fb: bunnymatic
      <br/>
    </div>
    <h2>Bunnymatic and Friends</h2>
    <div class='byline'>by Mr Rogers</div>
  EOM
end

def div v, attrs = {}
  attr_string = attrs.map do |k,v|
    "#{k}='#{v}'"
  end.join(' ')
  "<div #{attr_string}>\n#{v}\n</div>"
end
def span v, attrs = {}
  attr_string = attrs.map do |k,v|
    "#{k}='#{v}'"
  end.join(' ')
  "<span #{attr_string}>#{v}</span>"
end

filename = ARGV[0]
entries = []
CSV.foreach(filename, headers: true, header_converters: :symbol) do |row|
  entries << Hash[ row.to_a ]
end

#dolores_park_entries = entries.select{|e| e[:for_dolores_park] == 'TRUE'}.map{|e| e.delete(:for_dolores_park); e }
#entries = dolores_park_entries

decider_column = :fall_2016
entries = entries.select{|e| !e[decider_column].nil? && (/^\s+$/ !~ e[decider_column])} #.map{|e| e.delete(decider_column); e }


puts "<html>"
puts style
puts "<body>"
puts header

entries.each_with_index do |entry, idx|
  entry_body = [:name, :medium, :size, :date, :price].map do |key|
    v = entry[key]
    div(v, class: "entry-item #{key}")
  end
  puts div( ([span(idx+1, class: 'entry-number')] + entry_body).join("\n"), class: 'entry' )
  if ((idx + 1) % 12 == 0)
    puts div '&nbsp;', class: 'page-break'
  end
end
puts "</body>"
puts "</html>"



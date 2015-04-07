#!/bin/env ruby

require 'csv'
require 'awesome_print'

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

dolores_park_entries = entries.select{|e| e[:for_dolores_park] == 'TRUE'}.map{|e| e.delete(:for_dolores_park); e }

dolores_park_entries.each_with_index do |entry, idx|
  entry_body = [:name, :medium, :size, :date, :price].map do |key|
    v = entry[key]
    div(v, class: "entry-item #{key}")
  end
  puts div( ([span(idx+1, class: 'entry-number')] + entry_body).join("\n"), class: 'entry' )
end




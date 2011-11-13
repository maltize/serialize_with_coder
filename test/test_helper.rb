$:.unshift(File.dirname(__FILE__) + '/..')
$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'active_record'
require 'test/unit'

require 'serialize_with_coder'
require 'coders/csv_coder'
require 'coders/json_coder'

require 'init'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

[:users].each do |table|
  ActiveRecord::Base.connection.drop_table table rescue nil
end

ActiveRecord::Base.connection.create_table :users do |t|
  t.string :name
  t.text :newsletters
  t.text :notes
end

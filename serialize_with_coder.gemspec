Gem::Specification.new do |s|
  s.name        = 'serialize_with_coder'
  s.version     = '0.1.0'

  s.platform    = Gem::Platform::RUBY

  s.date        = '2011-11-12'
  s.summary     = "Serialize with Coder"
  s.description = "serialize_with_coder is an ActiveRecord extended serialize function which acts like Rails 3.1 one - you can use custom coder as storing engine. Including 2 sample coders - CSV and JSON."

  s.authors     = ["Maciej Gajek"]
  s.email       = 'maltize@gmail.com'
  s.homepage    = 'https://github.com/maltize/serialize_with_coder'

  s.files = Dir['{lib,test}/**/*']
  s.test_files = Dir['{test}/**/*']

  s.add_dependency "activerecord", "~> 2"
  s.add_dependency "json"

  s.add_development_dependency "sqlite3"
end
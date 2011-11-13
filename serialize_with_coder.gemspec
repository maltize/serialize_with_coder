Gem::Specification.new do |s|
  s.name        = 'serialize_with_coder'
  s.version     = '0.1.1'

  s.platform    = Gem::Platform::RUBY

  s.date        = '2011-11-13'
  s.summary     = "Serialize with Coder"
  s.description = "serialize_with_coder is an ActiveRecord 2.x extended serialize function which acts like Rails 3.1 one - you can use custom coder as storing engine. Including 2 sample coders - CSV and JSON."

  s.authors     = ["Maciej Gajek"]
  s.email       = 'maltize@gmail.com'
  s.homepage    = 'https://github.com/maltize/serialize_with_coder'

  s.files = [
    "lib/serialize_with_coder.rb",
    "lib/coders/csv_coder.rb",
    "lib/coders/json_coder.rb",
    "test/serialize_with_coder_test.rb",
    "test/test_helper.rb",
    "Rakefile",
    "README.md"
  ]

  s.test_files = [
    "test/serialize_with_coder_test.rb",
    "test/test_helper.rb"
  ]

  s.add_dependency "activerecord", "~> 2"
  s.add_dependency "json"

  s.add_development_dependency "sqlite3"
end
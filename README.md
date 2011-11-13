Serialize with Coder
====================

serialize_with_coder is an ActiveRecord extended serialize function which acts like Rails 3.1 one - you can use custom coder as storing engine.

Including 2 sample coders:

 - CSV, SerializeWithCoder::CSVCoder
 - JSON, SerializeWithCoder::JSONCoder

Example
-------

    require 'coders/csv_coder'
    require 'coders/json_coder'

    class User < ActiveRecord::Base

      serialize_with_coder :newsletters, SerializeWithCoder::CSVCoder.new
      serialize_with_coder :notes,       SerializeWithCoder::JSONCoder.new

    end

Installation
------------

    gem install serialize_with_coder

Note
----
Please open an issue at http://github.com/maltize/serialize_with_coder if you discover a problem.

* * *

Copyright (c) 2011 Maciej Gajek, released under the MIT license.
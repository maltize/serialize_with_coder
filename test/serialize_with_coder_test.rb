require 'test_helper'

class User < ActiveRecord::Base

  serialize_with_coder :newsletters, SerializeWithCoder::CSVCoder.new
  serialize_with_coder :notes,       SerializeWithCoder::JSONCoder.new

  def inspect
    attributes_as_nice_string = self.class.column_names.collect { |name|
      if has_attribute?(name)
        "#{name}: #{attribute_for_inspect(name)}"
      end
    }.compact.join(", ")
    "#<#{self.class} #{attributes_as_nice_string}>"
  end

end

class SerializeWithCoderTest < Test::Unit::TestCase

  def setup
    @user = User.create(:name => "Dhalsim")
  end

  def setup_notes
    @note = {
      'title' => 'First',
      'body' => 'Perfect body'
    }

    @note2 = {
      'title' => 'Second',
      'body' => 'Score!'
    }
  end

  # Serialize with CSV coder

  def test_serialize_to_csv
    @user.newsletters = ["FREE", "PREMIUM"]
    @user.save

    assert_equal "FREE,PREMIUM", @user.read_attribute(:newsletters)
  end

  def test_deserialized_from_csv
    @user.newsletters = ["FREE", "PREMIUM"]
    @user.save

    user = User.find(@user.id)

    assert_equal ["FREE", "PREMIUM"], user.newsletters
  end

  # Serialize with JSON coder

  def test_serialize_to_json
    setup_notes

    @user.notes = [@note, @note2]
    @user.save

    assert_match /\[.+\]/, @user.read_attribute(:notes)

    assert_match /\"title\":\"First\"/, @user.read_attribute(:notes)
    assert_match /\"body\":\"Perfect body\"/, @user.read_attribute(:notes)
    assert_match /\"title\":\"Second\"/, @user.read_attribute(:notes)
    assert_match /\"body\":\"Score!\"/, @user.read_attribute(:notes)
  end

  def test_deserialized_from_json
    setup_notes

    @user.notes = [@note, @note2]
    @user.save

    user = User.find(@user.id)

    assert user.notes.include?(@note)
    assert user.notes.include?(@note2)
  end

  # Serialize with both coders

  def test_serialize_with_both_coders
    setup_notes

    @user.newsletters = ["FREE", "PREMIUM"]
    @user.notes = [@note, @note2]

    @user.save

    user = User.find(@user.id)

    assert_equal ["FREE", "PREMIUM"], user.newsletters

    assert user.notes.include?(@note)
    assert user.notes.include?(@note2)
  end

  def test_changed
    assert !@user.newsletters_changed?

    @user.newsletters = ["FREE", "PREMIUM"]

    assert @user.newsletters_changed?
  end

  def test_change
    assert_nil @user.newsletters_change

    @user.newsletters = ["FREE", "PREMIUM"]

    assert_equal [[], ["FREE", "PREMIUM"]], @user.newsletters_change
  end

  def test_was
    assert_equal [], @user.newsletters_was

    @user.newsletters = ["FREE", "PREMIUM"]

    assert_equal [], @user.newsletters_was
  end

end
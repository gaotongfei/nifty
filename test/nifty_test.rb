require 'active_record'
require 'test_helper'

class NiftyTest < Minitest::Test
  def setup
    ::ActiveRecordTest.setup
    5.times do |i|
      ActiveRecordTest::User.create(username: "username#{i}", email: "email#{i}", password_digest: "password#{i}")
    end
  end

  def test_that_it_has_a_version_number
    refute_nil ::Nifty::VERSION
  end

  def test_active_record_relation
    assert_equal 5, ActiveRecordTest::User.all.nifty.size
  end

  def test_query_all
    ActiveRecordTest::User.all.nifty.each_with_index do |user, index|
      assert_equal "username#{index}", user.username
      assert_equal "email#{index}", user.email
      assert_equal "password#{index}", user.password_digest
    end
  end

  def test_query_where
    ActiveRecordTest::User.where(username: 'test0').nifty.each do |user|
      assert_equal 'username0', user.username
      assert_equal 'email0', user.email
      assert_equal 'password0', user.password_digest
    end
  end

  def test_nifty_batches
    count = 0
    ActiveRecordTest::User.all.nifty_batches(batch_size: 1) do |user|
      count += 1
    end
    assert_equal 5, count
  end
end

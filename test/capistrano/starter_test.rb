require 'test_helper'

class Capistrano::StarterTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Capistrano::Starter::VERSION
  end

  def test_it_does_something_useful
    assert true
  end
end

require_relative '../minitest_helper'

def test_reverse
  rose = 'a rose'
  assert_equal "#{rose}", 'esor a'.reverse!
end

describe 'a rose is a rose' do
  it 'even in reverse' do
    test_reverse
  end
end

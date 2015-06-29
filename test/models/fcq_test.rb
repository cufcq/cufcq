require_relative '../minitest_helper'

def test_reverse
  rose = 'a rose'
  assert_equal "#{rose}", 'esor a'.reverse!
end

describe Fcq do
  before do
    @data = {
      'yearterm' => 20151,
      'subject' => 'TEST',
      'crse' => 1000,
      'sec' => 3,
      'instructor_first' => 'Alejandro',
      'instructor_last' => 'Spina',
      'forms_requested' => 30,
      'forms_returned' => 20,
      'campus' => 'BD',
      'college' => 'AS'
    }
    @fcq = Fcq.new(@data)
  end
  describe 'a rose is a rose' do
    it 'even in reverse' do
      test_reverse
    end
  end
end

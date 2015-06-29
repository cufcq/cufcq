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
      'formsrequested' => 30,
      'formsreturned' => 20,
      'campus' => 'BD',
      'college' => 'AS'
    }
    @fcq = Fcq.new(@data)
  end

  describe 'float_passed' do
    it 'should base this value off of pct_c_minus_or_below' do
      (1..12).each do |i|
        @fcq.update_attribute(:pct_c_minus_or_below, 1.0 / i)
        @fcq.save
        assert_equal 1.0 - (1.0 / i), @fcq.float_passed
      end
    end
    it 'should still return a value when  pct_c_minus_or_below is null' do
      assert_equal 0.0, @fcq.float_passed
    end
  end

  describe 'pass_rate' do
    it 'should return 100% if everyone passed' do
      @fcq.update_attribute(:pct_c_minus_or_below, 0.0)
      @fcq.save
      assert_equal '100%', @fcq.pass_rate
    end
    it 'should return 0% if everyone failed' do
      @fcq.update_attribute(:pct_c_minus_or_below, 1.0)
      @fcq.save
      assert_equal '0%', @fcq.pass_rate
    end
    it 'should return "--" if it is unknown' do
      assert_equal '--', @fcq.pass_rate
    end
  end

  describe 'pct_a_string' do
    it 'should return 100% if everyone got As' do
      @fcq.update_attribute(:pct_a, 1.0)
      @fcq.save
      assert_equal '100%', @fcq.pct_a_string
    end
    it 'should return 0% if everyone got As' do
      @fcq.update_attribute(:pct_a, 0.0)
      @fcq.save
      assert_equal '0%', @fcq.pct_a_string
    end
    it 'should return "--" if it is unknown' do
      assert_equal '--', @fcq.pct_a_string
    end
  end

  describe 'pct_b_string' do
    it 'should return 100% if everyone got Bs' do
      @fcq.update_attribute(:pct_b, 1.0)
      @fcq.save
      assert_equal '100%', @fcq.pct_b_string
    end
    it 'should return 0% if everyone got Bs' do
      @fcq.update_attribute(:pct_b, 0.0)
      @fcq.save
      assert_equal '0%', @fcq.pct_b_string
    end
    it 'should return "--" if it is unknown' do
      assert_equal '--', @fcq.pct_b_string
    end
  end

  describe 'pct_c_string' do
    it 'should return 100% if everyone got Cs' do
      @fcq.update_attribute(:pct_c, 1.0)
      @fcq.save
      assert_equal '100%', @fcq.pct_c_string
    end
    it 'should return 0% if everyone got Cs' do
      @fcq.update_attribute(:pct_c, 0.0)
      @fcq.save
      assert_equal '0%', @fcq.pct_c_string
    end
    it 'should return "--" if it is unknown' do
      assert_equal '--', @fcq.pct_c_string
    end
  end

  describe 'pct_d_string' do
    it 'should return 100% if everyone got Ds' do
      @fcq.update_attribute(:pct_d, 1.0)
      @fcq.save
      assert_equal '100%', @fcq.pct_d_string
    end
    it 'should return 0% if everyone got Ds' do
      @fcq.update_attribute(:pct_d, 0.0)
      @fcq.save
      assert_equal '0%', @fcq.pct_d_string
    end
    it 'should return "--" if it is unknown' do
      assert_equal '--', @fcq.pct_d_string
    end
  end

  describe 'pct_f_string' do
    it 'should return 100% if everyone got Fs' do
      @fcq.update_attribute(:pct_f, 1.0)
      @fcq.save
      assert_equal '100%', @fcq.pct_f_string
    end
    it 'should return 0% if everyone got Fs' do
      @fcq.update_attribute(:pct_f, 0.0)
      @fcq.save
      assert_equal '0%', @fcq.pct_f_string
    end
    it 'should return "--" if it is unknown' do
      assert_equal '--', @fcq.pct_f_string
    end
  end


end

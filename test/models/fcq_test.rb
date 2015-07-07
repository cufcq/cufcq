require_relative '../minitest_helper'
# rake db:test:prepare

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

  describe 'course_overall_string' do
    it 'should not return -- if courseoverall is set' do
      @fcq.update_attribute(:courseoverall, 6.0)
      @fcq.save
      assert_equal '6.0 / 6.0', @fcq.course_overall_string
    end
    it 'should not return -- if courseoverall is set' do
      @fcq.update_attribute(:courseoverall, 0.0)
      @fcq.save
      assert_equal '0.0 / 6.0', @fcq.course_overall_string
    end
    it 'should not return -- if courseoverall is not set' do
      assert_equal '--', @fcq.course_overall_string
    end
  end

  describe 'instructor_overall_string' do
    it 'should not return -- if courseoverall is set' do
      @fcq.update_attribute(:instructoroverall, 6.0)
      @fcq.save
      assert_equal '6.0 / 6.0', @fcq.instructor_overall_string
    end
    it 'should not return -- if courseoverall is set' do
      @fcq.update_attribute(:instructoroverall, 0.0)
      @fcq.save
      assert_equal '0.0 / 6.0', @fcq.instructor_overall_string
    end
    it 'should not return -- if courseoverall is not set' do
      assert_equal '--', @fcq.instructor_overall_string
    end
  end

  describe 'challenge_string' do
    it 'should not return -- if courseoverall is set' do
      @fcq.update_attribute(:challenge, 6.0)
      @fcq.save
      assert_equal '6.0 / 6.0', @fcq.challenge_string
    end
    it 'should not return -- if courseoverall is set' do
      @fcq.update_attribute(:challenge, 0.0)
      @fcq.save
      assert_equal '0.0 / 6.0', @fcq.challenge_string
    end
    it 'should not return -- if courseoverall is not set' do
      assert_equal '--', @fcq.challenge_string
    end
  end

  describe 'prior_interest_string' do
    it 'should not return -- if priorinterest is set' do
      @fcq.update_attribute(:priorinterest, 6.0)
      @fcq.save
      assert_equal '6.0 / 6.0', @fcq.prior_interest_string
    end
    it 'should not return -- if priorinterest is set' do
      @fcq.update_attribute(:priorinterest, 0.0)
      @fcq.save
      assert_equal '0.0 / 6.0', @fcq.prior_interest_string
    end
    it 'should not return -- if priorinterest is not set' do
      assert_equal '--', @fcq.prior_interest_string
    end
  end

  describe 'howmuchlearned_string' do
    it 'should not return -- if howmuchlearned is set' do
      @fcq.update_attribute(:howmuchlearned, 6.0)
      @fcq.save
      assert_equal '6.0 / 6.0', @fcq.howmuchlearned_string
    end
    it 'should not return -- if howmuchlearned is set' do
      @fcq.update_attribute(:howmuchlearned, 0.0)
      @fcq.save
      assert_equal '0.0 / 6.0', @fcq.howmuchlearned_string
    end
    it 'should not return -- if howmuchlearned is not set' do
      assert_equal '--', @fcq.howmuchlearned_string
    end
  end

  describe 'avg_grd_string' do
    it 'should not return -- if avg_grd is set' do
      @fcq.update_attribute(:avg_grd, 4.0)
      @fcq.save
      assert_equal '4.0 / 4.0', @fcq.avg_grd_string
    end
    it 'should not return -- if avg_grd is set' do
      @fcq.update_attribute(:avg_grd, 2.456)
      @fcq.save
      assert_equal '2.46 / 4.0', @fcq.avg_grd_string
    end
    it 'should not return -- if avg_grd is not set' do
      assert_equal '--', @fcq.avg_grd_string
    end
  end

  describe 'collected_online?' do
    it 'should return true if collected_online? is set' do
      @fcq.update_attribute(:onlinefcq, 'OL')
      @fcq.save
      assert_equal true, @fcq.collected_online?
    end
    it 'should return false if collected_online is set' do
      assert_equal false, @fcq.collected_online?
    end
  end

  describe 'section_string, uid' do
    it 'section_string should return correctly' do
      assert_equal '003', @fcq.section_string
    end
    it 'uid should return correctly' do
      assert_equal "#{@data.yearterm}#{@data.subject}#{@data.crse}#{@data.sec}", @fcq.uid
    end
    it 'year return correctly' do
      assert_equal '2015', @fcq.year
    end
  end

  describe 'ld?, ud?, grad?, rank_string, rank_string_abridged' do
    it 'should return true for the appropriate level, and false for others' do
      ld = %w(1000, 1020, 1099, 2000, 2131, 2344, 2999)
      ud = %w(3000, 3020, 3099, 4000, 4131, 4344, 4999)
      gd = %w(5000, 5020, 5099, 6000, 6131, 6344, 6999)
      ld.each do |x|
        @fcq.update_attribute(:crse, x)
        @fcq.save
        assert_equal true, @fcq.ld?
        assert_equal false, @fcq.ud?
        assert_equal false, @fcq.grad?
        assert_equal 'Lower Division', @fcq.rank_string
        assert_equal 'ld', @fcq.rank_string_abridged
      end
      ud.each do |x|
        @fcq.update_attribute(:crse, x)
        @fcq.save
        assert_equal false, @fcq.ld?
        assert_equal true, @fcq.ud?
        assert_equal false, @fcq.grad?
        assert_equal 'Upper Division', @fcq.rank_string
        assert_equal 'ud', @fcq.rank_string_abridged
      end
      gd.each do |x|
        @fcq.update_attribute(:crse, x)
        @fcq.save
        assert_equal false, @fcq.ld?
        assert_equal false, @fcq.ud?
        assert_equal true, @fcq.grad?
        assert_equal 'Graduate Level', @fcq.rank_string
        assert_equal 'gd', @fcq.rank_string_abridged
      end
    end
  end

end

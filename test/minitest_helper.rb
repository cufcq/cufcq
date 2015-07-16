ENV['RAILS_ENV'] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rails/test_help'
require 'minitest/autorun'
# alteration to array class
class Array

  def average_hash(key)
    map { |x| x[key].to_f }.inject(:+) / length
  end

end

def fcq_data
  [
    _a,
    _b,
    _c,
    _d,
    _e
  ]
end

private

def all
  {
    'subject' => 'TEST',
    'crse' => 1000,
    'course_title' => 'Test Course',
    'sec' => 3,
    'instructor_first' => 'Alejandro',
    'instructor_last' => 'Spina',
    'formsrequested' => 30,
    'formsreturned' => 20,
    'campus' => 'BD',
    'college' => 'AS',
    'activity_type' => 'LEC - Lecture',
    'hours' => '3',
    'n_enroll' => '35',
    'n_incomp' => '0',
    'instr_group' => 'TTT'
  }
end
def _a
  data = {
    'yearterm' => 20151,
    'pct_a' => '0.3548387097',
    'pct_b' => '0.4193548387',
    'pct_c' => '0.1935483871',
    'pct_d' => '0.03225806452',
    'pct_f' => '0',
    'n_eot' => '31',
    'avg_grd' => '3.096774194',
    'pct_df' => '0.03225806452',
    'pct_c_minus_or_below' => '0.03225806452',
    'priorinterest' => '4.4',
    'challenge' => '3.7',
    'courseoverall' => '4.5',
    'hoursperwkinclclass' => '7-9',
    'howmuchlearned' => '5.2',
    'instructoroverall' => '6.0',
    'instreffective' => '3.8',
    'instrrespect' => '5.9',
    'availability' => '5.9'
  }
  all.merge(data)
end
def _b
  data = {
    'yearterm' => 20147,
    'pct_a' => '0.375',
    'pct_b' => '0.34375',
    'pct_c' => '0.1875',
    'pct_d' => '0.0625',
    'pct_f' => '0.03125',
    'n_eot' => '32',
    'avg_grd' => '2.96875',
    'pct_df' => '0.09375',
    'pct_c_minus_or_below' => '0.09375',
    'priorinterest' => '5.4',
    'challenge' => '3.2',
    'courseoverall' => '4.5',
    'hoursperwkinclclass' => '7-9',
    'howmuchlearned' => '5.4',
    'instructoroverall' => '5.6',
    'instreffective' => '5.8',
    'instrrespect' => '5.9',
    'availability' => '5.7'
  }
  all.merge(data)
end
def _c
  data = {
    'yearterm' => 20144,
    'pct_a' => '0.4848484848',
    'pct_b' => '0.303030303',
    'pct_c' => '0.1212121212',
    'pct_d' => '0.06060606061',
    'pct_f' => '0.0303030303',
    'n_eot' => '33',
    'avg_grd' => '3.151515152',
    'pct_df' => '0.09090909091',
    'pct_c_minus_or_below' => '0.09090909091',
    'priorinterest' => '5.4',
    'challenge' => '3.2',
    'courseoverall' => '4.4',
    'hoursperwkinclclass' => '7-9',
    'howmuchlearned' => '5.9',
    'instructoroverall' => '6.0',
    'instreffective' => '4.9',
    'instrrespect' => '6.0',
    'availability' => '6.0'
  }
  all.merge(data)
end
def _d
  data = {
    'yearterm' => 20141,
    'pct_a' => '0.5',
    'pct_b' => '0.2647058824',
    'pct_c' => '0.1176470588',
    'pct_d' => '0.08823529412',
    'pct_f' => '0.02941176471',
    'n_eot' => '34',
    'avg_grd' => '3.117647059',
    'pct_df' => '0.1176470588',
    'pct_c_minus_or_below' => '0.1176470588',
    'priorinterest' => '3.4',
    'challenge' => '4.2',
    'courseoverall' => '4.5',
    'hoursperwkinclclass' => '4-6',
    'howmuchlearned' => '5.6',
    'instructoroverall' => '6.0',
    'instreffective' => '5.3',
    'instrrespect' => '6.0',
    'availability' => '5.0'
  }
  all.merge(data)
end
def _e
  data = {
    'yearterm' => 20137,
    'pct_a' => '0.5428571429',
    'pct_b' => '0.2',
    'pct_c' => '0.1142857143',
    'pct_d' => '0.08571428571',
    'pct_f' => '0.05714285714',
    'n_eot' => '35',
    'avg_grd' => '3.085714286',
    'pct_df' => '0.1428571429',
    'pct_c_minus_or_below' => '0.1428571429',
    'priorinterest' => '4.1',
    'challenge' => '4.4',
    'courseoverall' => '4.9',
    'hoursperwkinclclass' => '4-6',
    'howmuchlearned' => '5.1',
    'instructoroverall' => '5.7',
    'instreffective' => '5.3',
    'instrrespect' => '5.4',
    'availability' => '4.9'
  }
  all.merge(data)
end

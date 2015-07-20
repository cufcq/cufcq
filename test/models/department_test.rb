require_relative '../minitest_helper'
  # rake db:test:prepare

describe Department do
  before do
    @data = {
      'name' => 'TEST',
      'long_name' => 'Testing',
      'college' => 'AS',
      'campus' => 'BD'
    }
    @department = Department.where(@data).first
  end

  describe 'name, slug' do
    it 'should correctly display the name' do
      assert_equal "#{@data['name']}", @department.name
    end
    it 'should correctly display the slug as the name' do
      @department.generate_slug
      assert_equal @department.name.parameterize, @department.slug
      assert_equal @department.slug, @department.to_param
    end
  end
end

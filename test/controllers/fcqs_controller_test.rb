require 'test_helper'

class FcqsControllerTest < ActionController::TestCase
  setup do
    @fcq = fcqs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fcqs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create fcq" do
    assert_difference('Fcq.count') do
      post :create, fcq: { amount_learned: @fcq.amount_learned, availability: @fcq.availability, campus: @fcq.campus, challenge: @fcq.challenge, college: @fcq.college, course_overall: @fcq.course_overall, course_overall_SD: @fcq.course_overall_SD, course_title: @fcq.course_title, crse: @fcq.crse, effectiveness: @fcq.effectiveness, forms_requested: @fcq.forms_requested, forms_returned: @fcq.forms_returned, instructor_first: @fcq.instructor_first, instructor_group: @fcq.instructor_group, instructor_last: @fcq.instructor_last, instructor_overall: @fcq.instructor_overall, instructor_overall_SD: @fcq.instructor_overall_SD, percentage_passed: @fcq.percentage_passed, prior_interest: @fcq.prior_interest, respect: @fcq.respect, sec: @fcq.sec, subject: @fcq.subject, total_hours: @fcq.total_hours, yearterm: @fcq.yearterm }
    end

    assert_redirected_to fcq_path(assigns(:fcq))
  end

  test "should show fcq" do
    get :show, id: @fcq
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @fcq
    assert_response :success
  end

  test "should update fcq" do
    patch :update, id: @fcq, fcq: { amount_learned: @fcq.amount_learned, availability: @fcq.availability, campus: @fcq.campus, challenge: @fcq.challenge, college: @fcq.college, course_overall: @fcq.course_overall, course_overall_SD: @fcq.course_overall_SD, course_title: @fcq.course_title, crse: @fcq.crse, effectiveness: @fcq.effectiveness, forms_requested: @fcq.forms_requested, forms_returned: @fcq.forms_returned, instructor_first: @fcq.instructor_first, instructor_group: @fcq.instructor_group, instructor_last: @fcq.instructor_last, instructor_overall: @fcq.instructor_overall, instructor_overall_SD: @fcq.instructor_overall_SD, percentage_passed: @fcq.percentage_passed, prior_interest: @fcq.prior_interest, respect: @fcq.respect, sec: @fcq.sec, subject: @fcq.subject, total_hours: @fcq.total_hours, yearterm: @fcq.yearterm }
    assert_redirected_to fcq_path(assigns(:fcq))
  end

  test "should destroy fcq" do
    assert_difference('Fcq.count', -1) do
      delete :destroy, id: @fcq
    end

    assert_redirected_to fcqs_path
  end
end

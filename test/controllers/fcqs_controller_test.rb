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
      post :create, fcq: { availability: @fcq.availability, campus: @fcq.campus, challenge: @fcq.challenge, college: @fcq.college, courseOverall: @fcq.courseOverall, courseOverallPctValid: @fcq.courseOverallPctValid, courseOverall_SD: @fcq.courseOverall_SD, crsTitle: @fcq.crsTitle, crse: @fcq.crse, formsReturned: @fcq.formsReturned, formsrequested: @fcq.formsrequested, hoursPerWkInclClass: @fcq.hoursPerWkInclClass, howMuchLearned: @fcq.howMuchLearned, instrEffective: @fcq.instrEffective, instrRespect: @fcq.instrRespect, instr_Group: @fcq.instr_Group, instructorOverall: @fcq.instructorOverall, instructorOverall_SD: @fcq.instructorOverall_SD, instructor_first: @fcq.instructor_first, instructor_last: @fcq.instructor_last, priorInterest: @fcq.priorInterest, sec: @fcq.sec, subject: @fcq.subject, yearterm: @fcq.yearterm }
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
    patch :update, id: @fcq, fcq: { availability: @fcq.availability, campus: @fcq.campus, challenge: @fcq.challenge, college: @fcq.college, courseOverall: @fcq.courseOverall, courseOverallPctValid: @fcq.courseOverallPctValid, courseOverall_SD: @fcq.courseOverall_SD, crsTitle: @fcq.crsTitle, crse: @fcq.crse, formsReturned: @fcq.formsReturned, formsrequested: @fcq.formsrequested, hoursPerWkInclClass: @fcq.hoursPerWkInclClass, howMuchLearned: @fcq.howMuchLearned, instrEffective: @fcq.instrEffective, instrRespect: @fcq.instrRespect, instr_Group: @fcq.instr_Group, instructorOverall: @fcq.instructorOverall, instructorOverall_SD: @fcq.instructorOverall_SD, instructor_first: @fcq.instructor_first, instructor_last: @fcq.instructor_last, priorInterest: @fcq.priorInterest, sec: @fcq.sec, subject: @fcq.subject, yearterm: @fcq.yearterm }
    assert_redirected_to fcq_path(assigns(:fcq))
  end

  test "should destroy fcq" do
    assert_difference('Fcq.count', -1) do
      delete :destroy, id: @fcq
    end

    assert_redirected_to fcqs_path
  end
end

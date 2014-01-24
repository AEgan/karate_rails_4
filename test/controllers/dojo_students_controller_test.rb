require 'test_helper'

class DojoStudentsControllerTest < ActionController::TestCase
  setup do
    @dojo_student = dojo_students(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dojo_students)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dojo_student" do
    assert_difference('DojoStudent.count') do
      post :create, dojo_student: { dojo_id: @dojo_student.dojo_id, end_date: @dojo_student.end_date, start_date: @dojo_student.start_date, student_id: @dojo_student.student_id }
    end

    assert_redirected_to dojo_student_path(assigns(:dojo_student))
  end

  test "should show dojo_student" do
    get :show, id: @dojo_student
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dojo_student
    assert_response :success
  end

  test "should update dojo_student" do
    patch :update, id: @dojo_student, dojo_student: { dojo_id: @dojo_student.dojo_id, end_date: @dojo_student.end_date, start_date: @dojo_student.start_date, student_id: @dojo_student.student_id }
    assert_redirected_to dojo_student_path(assigns(:dojo_student))
  end

  test "should destroy dojo_student" do
    assert_difference('DojoStudent.count', -1) do
      delete :destroy, id: @dojo_student
    end

    assert_redirected_to dojo_students_path
  end
end

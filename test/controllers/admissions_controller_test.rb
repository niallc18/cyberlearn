require "test_helper"

class AdmissionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admission = admissions(:one)
  end

  test "should get index" do
    get admissions_url
    assert_response :success
  end

  test "should get new" do
    get new_admission_url
    assert_response :success
  end

  test "should create admission" do
    assert_difference('Admission.count') do
      post admissions_url, params: { admission: { course_id: @admission.course_id, price: @admission.price, rating: @admission.rating, review: @admission.review, user_id: @admission.user_id } }
    end

    assert_redirected_to admission_url(Admission.last)
  end

  test "should show admission" do
    get admission_url(@admission)
    assert_response :success
  end

  test "should get edit" do
    get edit_admission_url(@admission)
    assert_response :success
  end

  test "should update admission" do
    patch admission_url(@admission), params: { admission: { course_id: @admission.course_id, price: @admission.price, rating: @admission.rating, review: @admission.review, user_id: @admission.user_id } }
    assert_redirected_to admission_url(@admission)
  end

  test "should destroy admission" do
    assert_difference('Admission.count', -1) do
      delete admission_url(@admission)
    end

    assert_redirected_to admissions_url
  end
end

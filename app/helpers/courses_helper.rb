module CoursesHelper
  def admission_button(course)
    if current_user
      if course.user == current_user
        link_to "View details", course_path(course)
      elsif course.admission.where(user: current_user).any?
        link_to "Already admitted", course_path(course)
      else
        link_to "Free", new_course_admission_path(course), class: 'btn btn-success'
      end
    else
      link_to "Details", course_path(course), class: "btn btn-md btn-success"
    end
  end
end

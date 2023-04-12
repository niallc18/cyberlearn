module CoursesHelper
  def admission_button(course)
    if current_user
      if course.user == current_user
        link_to "View details", course_path(course), class: "no-hyper"
      elsif course.admission.where(user: current_user).any?
        link_to course_path(course), class: "no-hyper" do
          raw("My Progress: ") +
          number_to_percentage(course.progression(current_user), precision: 0) #progession for lessons as percentage
        end
      else
        link_to "Free", new_course_admission_path(course), class: 'btn btn-success'
      end
    else
      link_to "Details", new_course_admission_path(course), class: "btn btn-md btn-success"
    end
  end
  
  def review_button(course)
    user_course = course.admission.where(user: current_user)
    if current_user
      if user_course.any?
        if user_course.review_needed.any?
          link_to 'Add review', edit_admission_path(user_course.first), class: "no-hyper"
        else
          link_to 'Check Review', admission_path(user_course.first), class: "no-hyper"
        end
      end
    end
  end

end

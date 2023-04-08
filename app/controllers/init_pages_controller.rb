class InitPagesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index]
  def first
    @courses = Course.all.limit(4)
    @trending_courses = Course.trending_courses
    @new_courses = Course.new_courses
  end
end

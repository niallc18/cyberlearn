class InitPagesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:first]
  def first
    @courses = Course.all
    @trending_courses = Course.approval.trending_courses
    @new_courses = Course.approval.new_courses
    @advanced_courses = Course.advanced_courses
    @beginner_courses = Course.beginner_courses
  end
end

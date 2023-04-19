class InitPagesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:first]
  def first
    @courses = Course.all
    @trending_courses = Course.approval.trending_courses
    @new_courses = Course.approval.new_courses
  end
end

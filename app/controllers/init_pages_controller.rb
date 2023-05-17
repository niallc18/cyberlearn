# scopes set for the view, skip before action method used to let non logged in users to see the first page
# include approval scope indicating the courses can only be shown if an admin has approved the course
# Reference: https://github.com/corsego/corsego
class InitPagesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:first]
  def first
    @courses = Course.all
    @trending_courses = Course.approval.trending_courses
    @new_courses = Course.approval.new_courses
    @advanced_courses = Course.approval.advanced_courses
    @beginner_courses = Course.approval.beginner_courses
  end
end

class InitPagesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [:index]
  def first
    @courses = Course.all.limit(3)
    @latest_courses = Course.all.limit(3).order(created_at: :desc)
  end
end

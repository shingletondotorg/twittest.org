class SchoolsController < ApplicationController
  def new
    @school = School.new
    @title = "Create school"
  end

  def create
    @school = School.new(params[:school])
    if @school.save
      flash[:success] = "School created!"
      redirect_to @school
    else
      @title = "Create School"
      render 'new'
    end
  end

  def index
    @title = "All Schools"
    @schools = School.paginate(:page => params[:page])
  end
  

  def show
     @school = School.find(params[:id])
     @title = @school.name
  end
  

end

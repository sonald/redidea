class PlansController < ApplicationController

  def index
    my_plan_path = ideas_path + "?scope=upload"
    redirect_to my_plan_path
  end

  # upload plan
  def create
    my_plan_path = ideas_path + "?scope=upload"
    @plan = current_user.plans.build(params[:plan])

    respond_to do |format|
      if @plan.save
        format.html { redirect_to my_plan_path, :notice => 'plan is successfully uploaded.' }
      else
        format.html { redirect_to my_plan_path, :notice => 'plan was unsuccessfully uploaded.' }
      end
    end
  end

  # update plan
  def update
    my_plan_path = ideas_path + "?scope=upload"
    @plan = current_user.plans.find_by_title(params[:plan][:title])
    if @plan.nil?
      @plan = current_user.plans.build(params[:plan])
      ret = @plan.save
    else
      ret = @plan.update_attributes(params[:plan])
    end

    respond_to do |format|
      if ret
        format.html { redirect_to my_plan_path, :notice => 'plan is successfully updated.' }
      else
        format.html { redirect_to my_plan_path, :notice => 'plan was unsuccessfully updated.' }
      end
    end
  end

end

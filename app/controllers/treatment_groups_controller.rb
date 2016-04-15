class TreatmentGroupsController < ApplicationController
  before_action :set_group, only: [:destroy, :update, :edit]

  def create
    @group = TreatmentGroup.new(treatment_group_params.merge(pro: current_user))
    if @group.save
      redirect_to treatments_url, notice: 'Treatment Group Created'
    else
      redirect_to :back, notice: @group.errors.full_messages.join(', ')
    end
  end

  def edit
  end

  def update
    if @group.pro == current_user && @group.update(treatment_group_params)
      redirect_to treatments_path, notice: 'group updated'
    else
      redirect_to :back, notice: @group.errors.full_messages.join(', ')
    end
  end

  def destroy
    @group.destroy
    redirect_to treatments_path, notice: 'group was deleted'
  end

  private

  def set_group
    @group = TreatmentGroup.find(params[:id])
  end

  def treatment_group_params
    params.require(:treatment_group).permit(:name)
  end
end
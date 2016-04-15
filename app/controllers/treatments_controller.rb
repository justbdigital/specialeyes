class TreatmentsController < ApplicationController
  before_action :set_treatment, only: [:destroy, :update]

  def index
    @treatments_with_groups = Treatment.where(pro: current_user).group_by(&:treatment_group)
    @groups = TreatmentGroup.where(pro: current_user) - @treatments_with_groups.keys
  end

  def new
    @group_id = params[:group_id]
    @treatment = Treatment.new
  end

  def edit
    @treatment = current_user.treatment
  end

  def create
    @treatment = Treatment.new(treatment_params.merge(pro: current_user))
    if @treatment.save
      redirect_to treatments_path, notice: 'Treatment Created'
    else
      redirect_to :back, notice: @treatment.errors.full_messages.join(', ')
    end
  end

  def update
    if @treatment.pro == current_user && @treatment.update(update_params)
      redirect_to treatments_path, notice: 'Treatment Updated'
    else
      redirect_to :back, notice: @treatment.errors.full_messages.join(', ')
    end
  end

  def destroy
    @treatment.destroy
    redirect_to treatments_path, notice: 'Treatment was deleted'
  end

  private

  def set_treatment
    @treatment = Treatment.find(params[:id])
  end

  def treatment_params
    params.require(:treatment).permit(:title, :treatment_type, :description, :sale_price, :price, :duration, :treatment_group_id)
  end

  def update_params
    params.require(:treatment).permit(:title, :treatment_type, :description, :sale_price, :price, :duration)
  end
end

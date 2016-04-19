class TreatmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_treatment, only: [:edit, :destroy, :update]

  def index
    @groups = TreatmentGroup.where(pro: current_user) - treatments_with_groups.keys
    @treatments_with_groups
  end

  def new
    authorize Treatment
    @group_id = params[:group_id]
    @treatment = Treatment.new
  end

  def edit
    authorize @treatment
  end

  def create
    @treatment = Treatment.new(treatment_params.merge(pro: current_user))
    authorize @treatment
    if @treatment.save
      redirect_to treatments_path, notice: 'Treatment Created'
    else
      redirect_to :back, notice: @treatment.errors.full_messages.join(', ')
    end
  end

  def update
    authorize @treatment
    if @treatment.update(update_params)
      redirect_to treatments_path, notice: 'Treatment Updated'
    else
      redirect_to :back, notice: @treatment.errors.full_messages.join(', ')
    end
  end

  def destroy
    authorize @treatment
    @treatment.destroy
    redirect_to treatments_path, notice: 'Treatment was deleted'
  end

  private

  def treatments_with_groups
    @treatments_with_groups ||= Treatment.where(pro: current_user).group_by(&:treatment_group)
  end

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

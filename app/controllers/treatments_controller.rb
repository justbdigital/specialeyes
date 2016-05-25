class TreatmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_treatment, only: [:edit, :destroy, :update, :select_featured]

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

  def select_featured
    redirect_to treatments_path, notice: '3 featured treatments max, you need to undo selection first' and return unless featured_selection_allowed?
    redirect_to treatments_path, notice: 'impossible to mark as featured' and return unless params[:featured]

    case params[:featured]
    when 'true'
      @treatment.update(featured: true)
      redirect_to treatments_path, notice: 'treatment is now featured'
    when 'false'
      @treatment.update(featured: false)
      redirect_to treatments_path, notice: 'treatment is now not featured'
    end
  end

  private

  def featured_selection_allowed?
    (current_user.treatments.where(featured: true).count < 3) || params[:featured] == 'false'
  end

  def treatments_with_groups
    @treatments_with_groups ||= Treatment.order(:title).where(pro: current_user).group_by(&:treatment_group)
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

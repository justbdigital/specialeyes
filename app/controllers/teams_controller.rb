class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_team, only: [:add_member, :show, :check_for_team]

  def show
  end

  def check_for_team
    render :show
  end

  def create
    @team = Team.new(owner: current_user)
    authorize @team
    if @team.save
      redirect_to team_path(@team), notice: 'Team Created'
    else
      redirect_to :back, notice: @team.errors.full_messages.join(', ')
    end
  end

  def add_member
    updated_team = Team.find(params[:id])
    authorize updated_team
    if !params['recipients']
      redirect_to :back, notice: 'Select members'
    else
      new_members
      redirect_to team_path(@team), notice: 'New members added'
    end
  end

  private

  def new_members
    members = Pro.where(id: params['recipients'].map { |p| p.split.last.gsub(/^\(+|\)+$/, '') })
    @team.members << members
  end

  def set_team
    @team ||= Team.find_by(owner_id: current_user.id)
  end
end

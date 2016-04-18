class TreatmentGroupPolicy < ApplicationPolicy

  def new?
    user.present? && user.is_a?(Pro)
  end

  def edit?
    record.pro == user
  end

  def create?
    new?
  end

  def update?
    edit?
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end

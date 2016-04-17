class TreatmentGroupPolicy < ApplicationPolicy

  def create?
    user.present?
  end

  def update?
    record.pro == user
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

class TeamPolicy < ApplicationPolicy

  def create?
    user.present? && user.is_a?(Pro)
  end

  def add_member?
    record.owner == user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end

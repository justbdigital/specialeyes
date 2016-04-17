class TeamPolicy < ApplicationPolicy

  def create?
    user.present?
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

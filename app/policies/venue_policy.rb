class VenuePolicy < ApplicationPolicy

  def create?
    user.present?
  end

  def update?
    record.pro == user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end

class BookingPolicy < ApplicationPolicy

  def index?
    user.present? && user.is_a?(Pro)
  end

  def create?
    user.present?
  end

  def mark_as_unavailable?
    user.present? && user.is_a?(Pro)
  end

  def destroy?
    record.pro == user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end

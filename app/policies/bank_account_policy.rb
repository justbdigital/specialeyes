class BankAccountPolicy < ApplicationPolicy

  def new?
    user.present? && user.is_a?(Pro)
  end

  def create?
    new?
  end

  def edit?
    record.pro == user
  end

  def update?
    edit?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end

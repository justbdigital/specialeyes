class BalancePolicy < ApplicationPolicy

  def create?
    user.present? && user.is_a?(Consumer) && !user.balance
  end

  def show?
    record.consumer == user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end

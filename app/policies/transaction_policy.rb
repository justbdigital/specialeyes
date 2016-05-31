class TransactionPolicy < ApplicationPolicy

  def new?
    user.present? && user.is_a?(Consumer)
  end

  def create?
    new?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end

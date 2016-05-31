class VoucherPolicy < ApplicationPolicy

  def add_gift?
    user.present? && user.is_a?(Consumer) && !record.used
  end

  def update?
    user.present? && user.is_a?(Consumer)
  end

  def buy_gift_card?
    update?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end

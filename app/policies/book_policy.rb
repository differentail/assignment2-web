# frozen_string_literal: true

class BookPolicy < ApplicationPolicy
  def create?
    !user.blank?
  end

  def update?
    create? && user == record.user
  end

  def destroy?
    update?
  end
end

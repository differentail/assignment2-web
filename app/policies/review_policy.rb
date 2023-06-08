# frozen_string_literal: true

class ReviewPolicy < ApplicationPolicy
  def create?
    !user.nil?
  end

  def update?
    create? && user == record.user
  end

  def destroy?
    update?
  end
end

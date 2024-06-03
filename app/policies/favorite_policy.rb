class FavoritePolicy < ApplicationPolicy
  attr_reader :user, :favorite

  def initialize(user, favorite)
    @user = user
    @favorite = favorite
  end

  def create?
    user.present?
  end

  def destroy?
    user.present? && (favorite.user == user)
  end

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end


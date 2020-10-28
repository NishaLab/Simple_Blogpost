# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize user
    alias_action :create, :read, :update, :destroy, to: :crud

    if user.nil?
      can :create, User
    else
      # User privilege for Micropost
      can :read, Micropost
      can :manage, Micropost, user_id: user.id
      can :manage, Micropost if user.has_role? :admin
      # User privilege for User model
      can :show, User
      can [:update, :destroy, :export], User, id: user.id
      can :manage, User if user.has_role? :admin

      # User privilage for Reaction Model
      can :crud, Reaction

      # User privilage to Relationship Model
      can [:read, :create], Relationship
      can [:update, :destroy], Relationship, follower_id: user.id
    end
  end
end

# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud

    unless user.nil?
      # User privilege for Micropost
      can :read, Micropost
      can :manage, Micropost, user_id: user.id
      if user.admin?
        can :manage, Micropost
      end
      #User privilege for User model
      can :show, User
      can [:update, :destroy, :export], User, id: user.id
      if user.admin?
        can :manage, User
      end

      #User privilage for Reaction Model
      can :crud, Reaction

      #User privilage to Relationship Model
      can [:read, :create], Relationship
      can [:update, :destroy], Relationship, follower_id: user.id
    else
      can :create , User
    end
  end
end

class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :create, :read, :update, :destroy, to: :crud

    user ||= User.new

    if user&.class == User
      can :manage, User, id: user.id
      can :read, Product
      can :read, Chat, id: user.chat.id
      can :read, Message, sender_id: user.id
    elsif user&.class == Superuser
      can :manage, User
      can :manage, Product
      can :manage, Superuser
      can :manage, Chat
      can :manage, Message
    end
  end
end

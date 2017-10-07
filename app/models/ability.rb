class Ability
  include CanCan::Ability

  def initialize(user)
      user ||= User.new
      puts user.role_name
      send("#{user.role_name}_role")
  end

  def user_role
    can :read, :all
    can [:new, :create], Score
    cannot :manage, User
    cannot :manage, Subject
    cannot :manage, Exam
  end
  def teacher_role
    can :manage, :all
    cannot [:update, :destroy], User
    cannot [:destroy], Subject
  end
  def admin_role
    can :manage, :all
    cannot [:destroy], User
  end
end
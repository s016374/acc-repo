class UserPolicy < ApplicationPolicy
  # Only two kind of role in the project, so new?, edit? ... are the same implement, using ghost method.
  # And Notice, MUST undefine methods like new?, edit? ... in super class ApplicationPolicy.
  # If having many kind of role, need to define method (def new?, def edit?) individually to implement.
  def method_missing(method_name, *arg, &blk)
     return is_authorized? if %w(new? edit? update? create? destroy? purchase?).include?(method_name.to_s)
     super
  end

  def is_authorized?
    ENV['AUTHORIZED_ACCOUTS'].split(',').include?(user.email)
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end

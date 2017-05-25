class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def show?
    false
    #  en fait il faudrait préciser
    #  n'importe qui de loggué peut voir le profil complet des coaches de ses groupes
    #  n'importe qui peut voir le profil partiel des coaches: firstname + photo + description
  end

  def update?
    record == user
  end

end

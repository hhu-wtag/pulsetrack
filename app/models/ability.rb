# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, team)
    return unless user && team

    membership = user.memberships.find_by(team: team)

    return unless membership

    if membership.admin?
      can :manage, Team, id: team.id
      can :manage, MonitoredSite, team_id: team.id
      can :manage, Membership, team_id: team.id
    elsif membership.editor?
      can :read, Team, id: team.id
      can [ :create, :read, :edit ], MonitoredSite, team_id: team.id
      can :read, Membership, team_id: team.id
    elsif membership.viewer?
      can :read, Team, id: team.id
      can :read, MonitoredSite, team_id: team.id
      can :read, Membership, team_id: team.id
    end
  end
end

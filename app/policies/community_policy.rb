class CommunityPolicy < ApplicationPolicy
  def community
    record
  end

  def join?
    return true unless person
    person.memberships.where(community: community).empty?
  end

  def list_members?
    return true if person && person.staff?
    return false unless person && community
    MembershipPolicy.new(person, community.memberships).index?
  end

  def show?
    person&.staff?
  end

  def update?
    show?
  end
end

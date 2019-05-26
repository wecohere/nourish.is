staff_member = Person.find_or_create_by(email: 'staff@example.com')
  .tap { |o| o.update(password: 'Password123', staff: true) }
zinc_community = Community.find_or_create_by(slug: :zinc)
  .tap { |o| o.update(name: "Zinc") }

  moderator =  Person.find_or_create_by(email: 'moderator@example.com')
  .tap { |o| o.update(password: 'Password123') }
moderator_membership = zinc_community.memberships.find_or_create_by(person: moderator)
  .tap { |o| o.update(status: :moderator, status_updated_at: Time.now,
                      name: moderator.email, email: moderator.email) }

community_member = Person.find_or_create_by(email: 'member@example.com')
  .tap { |o| o.update(password: 'Password123') }
community_member_membership =
  zinc_community.memberships.find_or_create_by(person: community_member)
  .tap { |o| o.update(status: :member, status_updated_at: Time.now,
                      name: community_member.email, email: community_member.email ) }

guest_member = Person.find_or_create_by(email: 'guest@example.com')
  .tap { |o| o.update(password: "Password123") }
guest_member_membership =
  zinc_community.memberships.find_or_create_by(person: community_member)
  .tap { |o| o.update(status: :guest, status_updated_at: Time.now,
                      name: guest_member.email, email: guest_member.email) }

nourish_community = Community.find_or_create_by(slug: :nourish)
  .tap { |o| o.update(name: "Nourish") }

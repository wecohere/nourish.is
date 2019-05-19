require 'rails_helper'

RSpec.describe MembershipPolicy do
  let(:guest) { create(:person) }
  let(:member) { create(:person) }
  let(:staff) { create(:person, :staff) }
  let(:moderator) { create(:person) }
  let(:community) { create(:community) }
  let!(:guest_membership) { create(:membership, :guest, community: community, person: guest) }
  let!(:membership_involved) { create(:membership, :member, community: community, person: member) }
  let!(:moderator_membership) { create(:membership, :moderator, community: community, person: moderator) }
  let!(:membership_not_involved) { create(:membership) }

  describe 'approval?' do
    context 'when moderator has a membership in the community' do
      it 'allows access' do
        expect(MembershipPolicy.new(moderator, moderator_membership).approval?).to be true
      end
    end

    context 'when person is nourish staff' do
      it 'allows access' do
        expect(MembershipPolicy.new(staff, nil).approval?).to be true
      end
    end

    context 'when person is only a guest in the community' do
      let!(:membership_involved) { create(:membership, :guest, community: community, person: member) }
      it 'denies access' do
        expect(MembershipPolicy.new(member, membership_involved).approval?).to be_falsey
      end
    end
  end

  describe 'show_email?' do
    context 'when moderator has a membership in the community' do
      it 'allows access' do
        expect(MembershipPolicy.new(moderator, moderator_membership).show_email?).to be true
      end
    end

    context 'when person is nourish staff' do
      it 'allows access' do
        expect(MembershipPolicy.new(staff, nil).show_email?).to be true
      end
    end

    context 'when person is only a member in the community' do
      let!(:membership_involved) { create(:membership, :member, community: community, person: member) }
      it 'denies access' do
        expect(MembershipPolicy.new(member, membership_involved).show_email?).to be_falsey
      end
    end

    context 'when person is only a guest in the community' do
      let!(:membership_involved) { create(:membership, :guest, community: community, person: member) }
      it 'denies access' do
        expect(MembershipPolicy.new(member, membership_involved).show_email?).to be_falsey
      end
    end
  end

  describe MembershipPolicy::Scope do
    describe 'resolve' do
      subject { described_class.new(member, nil).resolve }
      context 'returns memberships that the person is involved' do
        it { is_expected.to include membership_involved }
        it { is_expected.to_not include membership_not_involved }
      end

      context 'when person is nourish staff' do
        subject { described_class.new(staff, nil).resolve }
        it { is_expected.to include membership_involved }
        it { is_expected.to include membership_not_involved }
      end
    end
  end
end

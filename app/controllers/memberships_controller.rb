class MembershipsController < ApplicationController
  before_action :authenticate_person!, only: :index
  after_action :verify_authorized, only: [:index, :approval]
  after_action :verify_policy_scoped, only: :index

  def index
    authorize Membership
    @memberships = policy_scope(Membership).where(community: community)
  end

  def new
    @membership = community.memberships.build
  end

  def create
    @membership = community.memberships.build_new_member(membership_params)

    if @membership.save
      render :create
    else
      render :new
    end
  end

  def approval
    @membership = Membership.find_by!(id: params[:membership_id])
    authorize @membership
    @membership.approve!
    redirect_to community_memberships_path(@membership.community.slug)
  end

  private

  def community
    @community ||= Community.find_by!(slug: params[:community_id])
  end

  def membership_params
    params.require(:membership).permit(:name, :email)
  end
end

class InvitationsController < ApplicationController
	before_action :require_user

  def new
  	@invitation = Invitation.new
  end

  def create
  	invitation = Invitation.new(invitation_params.merge!(inviter_id: current_user.id))
  	AppMailer.send_invitation_email(invitation).deliver
  	if invitation.save
  	  flash[:notice] = "A new invitation was sent!"
  	  redirect_to new_invitation_path
  	else
  		render 'new'
  	end
  end

  private

  def invitation_params
  	params.require(:invitation).permit(:recipient_name, :recipient_email, :message, :inviter_id)
  end
end
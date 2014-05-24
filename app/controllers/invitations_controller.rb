class InvitationsController < ApplicationController
	before_action :require_user

  def new
  	@invitation = Invitation.new
  end

  def create
  	@invitation = Invitation.new(invitation_params.merge!(inviter_id: current_user.id))
  	if @invitation.save
  		AppMailer.delay.send_invitation_email(@invitation)
  	  flash[:notice] = "A new invitation was sent!"
  	  redirect_to new_invitation_path
  	else
  		flash[:danger] = "There is something wrong with your input!"
  		render 'new'
  	end
  end

  private

  def invitation_params
  	params.require(:invitation).permit(:recipient_name, :recipient_email, :message, :inviter_id, :token)
  end
end
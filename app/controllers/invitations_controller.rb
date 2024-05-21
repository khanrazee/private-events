class InvitationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.find(params[:event_id])
    @invitation = @event.invitations.build
  end

  def edit
    @invitation = Invitation.find(params[:id])
  end

  def respond_to_invitation
    @invitation = current_user.invitations.find(params[:id])
    @event = @invitation.event

    response_status = case params[:response]
                      when 'accept'
                        :accepted
                      when 'decline'
                        :declined
                      when 'maybe'
                        :maybe
                      else
                        :pending
                      end

    if @invitation.update(status: response_status)
      if response_status == :accepted || response_status == :maybe
        @event.attendees << current_user unless @event.attendees.include?(current_user)
      end
      create_response_notification(@invitation.invited_by_id, @invitation, response_status)
      redirect_to @event, notice: "Invitation #{response_status}."
    else
      redirect_to @event, alert: "Unable to update invitation status."
    end
  end

  def index
    @invitations = Invitation.where(invitee_id: current_user.id)
  end

  def create
    @event = Event.find(params[:event_id])
    @invitation = @event.invitations.build(invitation_params)
    @invitation.invitee = User.find(params["invitation"]["invitee_id"])
    @invitation.invited_by_id = current_user.id

    if Invitation.where(event_id: @event.id, invitee_id: @invitation.invitee_id).count > 0
      redirect_to @event, alert: 'Invitation for this event has already been sent to this user.'
    else
      if @invitation.save
        create_notification(@invitation.invitee, @invitation)
        redirect_to @event, notice: 'Invitation was successfully sent.'
      else
        render :new, alert: 'Unable to send invitation.'
      end
    end
  end

  def update
    @invitation = Invitation.find(params[:id])
    if @invitation.update(accepted: true)
      redirect_to @invitation.event, notice: 'Invitation accepted.'
    else
      redirect_to @invitation.event, alert: 'Unable to accept invitation.'
    end
  end

  def destroy
    @invitation = Invitation.find(params[:id])
    @invitation.destroy
    redirect_to root_path, notice: 'Invitation declined.'
  end

  private

  def invitation_params
    params.require(:invitation).permit(:event_id, :invitee_id)
  end

  def create_notification(user, invitation)
    Notification.create(
      recipient: user,
      actor: current_user,
      action: 'invited you to',
      notifiable: invitation
    )
  end

  def create_response_notification(user_id, invitation, response_status)
    action = case response_status
             when :accepted
               'accepted'
             when :declined
               'declined'
             when :maybe
               'responded with "maybe" to'
             else
               'responded to'
             end

    Notification.create(
      recipient: User.find(user_id),
      actor: current_user,
      action: "#{action} your invitation for",
      notifiable: invitation
    )
  end
end

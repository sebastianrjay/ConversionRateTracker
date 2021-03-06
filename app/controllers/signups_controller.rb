class SignupsController < ApplicationController

  def create
    @signup = Signup.new(
        invited_user_cookie: cookies[:invited_user_cookie],
        referring_gmail_address: params[:referring_gmail_address],
        first_name: params[:first_name], last_name: params[:last_name],
        email: params[:email], linkedin_url: params[:linkedin_url]
      )
      
    if @signup.save
      redirect_to(url_for(controller: :signups, action: :show,
        id: Base64.urlsafe_encode64(params[:first_name])))
    else
      already_signed_up = @signup.errors.full_messages.any? do |msg|
        msg == "Invited user cookie has already been taken" ||
          msg == "Email has already been taken"
      end

      if already_signed_up
        flash[:errors] = ["You've already signed up to Concierge. Please let us
          know if it's been more than a week and you haven't heard anything."]
      else
        flash[:errors] = @signup.errors.full_messages
      end

      redirect_to(url_for(controller: :invites, action: :show,
        id: Base64.urlsafe_encode64(params[:referring_gmail_address])))
    end
  end

  def show; end
end

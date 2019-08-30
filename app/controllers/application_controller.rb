class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, except: [:home, :about, :contact]
  
  respond_to :html, :json  
    
  require 'CSV'
  
  def home
  end

  def about
  end
  
  def contact
  end

  def secret
  end

  def send_invite
    invitee_user = User.find(params["invitee_user"])
    if invitee_user.inviter.nil?
      invitee_user.inviter = current_user
      invitee_user.save!
      flash[:notice] = "Invite Successfully Sent to #{invitee_user.full_name}"
    else
      flash[:notice] = "This user is already invited"
    end
    return redirect_to home_path
  end
  
  def accept_invite
    current_user.calculate_inviter_score_and_change_status    
    flash[:notice] = "Invite Accepted"
    return redirect_to home_path
  end
  
  def get_scores
  end
  
  def respond_scores
    myfile = params[:file]
    emails = CSV.read(myfile.path, 'r:bom|utf-8').flatten # 'r:bom|utf-8 BECAUSE i encountered some invisible
                                                          # bom(byte order mark) characters in csv disturbing the result
                                                          # while entering emails into csv.
    names_with_scores = User.where(email: emails).as_json(only:[:first_name, :score]).as_json
    respond_to do |format|
      format.json { render json: names_with_scores}
    end
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
end

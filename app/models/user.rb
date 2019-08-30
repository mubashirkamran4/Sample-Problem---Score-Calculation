class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :invitees, class_name: "User", foreign_key: "inviter_id"
  belongs_to :inviter, class_name: "User", optional: true
    
  def self.all_users_except_current(user_id)
    User.where.not(id: user_id)
  end
  
  def self.users_with_invitation_status_except_current(user_id)
    users_list = all_users_except_current(user_id)
    can_try_invite = users_list.where(can_invite: false)# if they are not invited yet or they have been invited
                                                        # by someone else before current user. current user's invitation
                                                        # would not be counted
    # THESE TWO LISTS ARE JUST FOR DISPLAY. NOT REALLY NEEDED AS THEY HIT DATABASE AGAIN FOR QUERYING
    invite_accepted_by_current_user = users_list.where(can_invite: true, inviter_id: user_id) # already invited and accepted 
    invite_accepted_by_other_users = users_list.where.not(inviter_id: user_id).where(can_invite: true)
    users_with_invite_status = { 
                                 can_try_invite: can_try_invite,
                                 invite_accepted_by_current_user: invite_accepted_by_current_user,
                                 invite_accepted_by_other_users: invite_accepted_by_other_users
                                }
  end
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
  def calculate_inviter_score_and_change_status
    # the calculation of the score starts with the immediate parent of the invitee and goes up till top  
    # most parent. scorer.inviter tells the immediate parent of the invitee.
    score_level = 0
    scorer = self.inviter
    while scorer
      scorer.score += ((1/2.0) ** score_level)
      scorer.save!
      scorer = scorer.inviter
      score_level += 1
    end
    self.can_invite = true
    self.save!
  end
  
end

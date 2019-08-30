PROBLEM STATEMENT

A company is planning a way to reward customers for inviting their friends. They're planning a reward system that will give a customer points for each confirmed invitation they played a part into. The definition of a confirmed invitation is one where an invited person accepts their contract. Inviters also should be rewarded when someone they have invited invites more people.
The inviter gets (1/2)^k points for each confirmed invitation, where k is the level of the invitation: level 0 (people directly invited) yields 1 point, level 1 (people invited by someone invited by the original customer) gives 1/2 points, level 2 invitations (people invited by someone on level 1) awards 1/4 points and so on. Only the first invitation counts: multiple invites sent to the same person don't produce any further points, even if they come from different inviters and only the first invitation counts.
So the input of
  2018-06-12 09:41 A recommends B
  2018-06-14 09:41 B accepts
  2018-06-16 09:41 B recommends C
  2018-06-17 09:41 C accepts
  2018-06-19 09:41 C recommends D
  2018-06-23 09:41 B recommends D
  2018-06-25 09:41 D accepts
would calculate as:
A receives 1 Point from the recommendation of B, ½ Point from the recommendation of C by B and another ¼ Point by the recommendation of D by C. A gets a total score of 1.75 Points.
B receives 1 Point from the recommendation of C and ½ Point from the recommendation of D by C. B receives no Points from the recommendation of D because D was invited by C before. B gets a total score of 1.5 Points. 
C receives 1 Point from the recommendation of D. C gets a total score of 1 Point.

Task
Implement the solution using Ruby. 
Briefly document the decisions you’ve taken in the process and why you’ve chosen so.
Test your implementation against the data provided.
Provide a simple Webservice accepting a file with input data and returning a set of scores for the contained customers. (Example: { “A”: 1.75, “B”: 1.5, “C”: 1 })





----------------
SOLUTION

STEPS TO RUN

1). Open terminal and navigate to the project directory after cloning.Run "bundle install". You might need to install
ruby version 2.3.0 by using command "rvm install 2.3.0" before running this command. The repository from where I cloned 
just to start the project was already using this version of ruby.

2). Run "rake db:create db:migrate db:seed". If this command gives error, just try to run in three different
steps as:
  i). rake db:create
  ii). rake db:migrate
  iii). rake db:seed
  Assumption: The "rake db:seed" command creates the very first user who can invite other users without being 
  invited by anyone else.

4). Run "rails s". Open browser and go to "localhost:3000". You should see the home page of the application.

5). On the top right you can see the "register" and "login" buttons for going to sign up and sign in pages 
respectively. When you login after being registered, you can see your score calculated till now, users that are 
possible to be invited and the users who have accepted someone's or your invitation. General assumption is that
if you have accepted your invitation only then you can invite others, in that case you would see that someone 
has invited you and you can accept his invitation.




DESIGN AND WORKFLOW

I started this project by cloning the sample repository https://github.com/bilalbash/rails_5_devise_app just for starting
my project as it has some nice styling already done so it might include some useless code or icons on the screen.

1).MODEL


I just used the user model as a business model and added the columns "can_invite", "score" and "inviter_id" for this
purpose. I am self joining the user model by "inviter_id" for viewing the users invited by a user or to view the 
inviter of the user because both invitee and inviter are users. https://guides.rubyonrails.org/association_basics.html#self-joins . "score" column holds the score of the current user when his invite was accepted or his invitee has invited other
person and that person accepted the invite and so on. "can_invite" is the column that tells if the person is allowed
to invite some person or not. He will only be allowed to invite if he was invited by someone and he accepts the invite
except the very first user. 


2). CALCULATION OF SCORE
With the help of "inviter_id", it becomes easy to keep track of who was invited by whom. So when someone accepts the
invite of the inviter, we can go bottom up to the top most inviter and calculate score on the way as can be 
seen in "calculate_inviter_score_and_change_status" method in user model file. As we go each level up, the score_level
is increased by 1 starting from 0(k mentioned in ppt).

3). For web service, I have provided the button "get scores" on the home page of the user and also the sample file
called "users_list.csv" in the project directory. This file should contain the emails of the users for which you
want to get scores of and it simply returns the json as a result.

PLEASE NOTE I have just focused the problem on hand and didn't implement the proper validations and security 
for each and every component.
Moreover, as you can see all the requests handling code was put in application controller because our application
just contained one main page(home) where we are doing all stuff. So, I didn't focus on separating controller and
making proper MVC as this was thought to be a little bit out of the scope of the problem.
I just used master branch because I was the only one contributor and the feature was not too complex for having multiple branches to be spread out.


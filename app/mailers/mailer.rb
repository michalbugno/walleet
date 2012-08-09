class Mailer < ActionMailer::Base
  default from: "roach@walleet.com"

  def invitation(person)
    @url = edit_person_password_url(:reset_password_token => person.reset_password_token)

    mail(:to => person.email, :subject => "Someone has invited you to a walleet group")
  end
end

class Mailer < ActionMailer::Base
  default from: "roach@walleet.com"

  def invitation(person)
    host = Rails.configuration.action_mailer.default_url_options[:host]
    @url = "http://#{host}/#person/reset_password/#{person.reset_password_token}"

    mail(:to => person.email, :subject => "Someone has invited you to a walleet group")
  end
end

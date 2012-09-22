class Mailer < ActionMailer::Base
  default from: "roach@walleet.com"

  def invitation(person)
    @url = "http://#{host}/person/reset_password/#{person.reset_password_token}"

    mail(:to => person.email, :subject => "Someone has invited you to a walleet group")
  end

  def welcome(person)
    @url = "http://#{host}"
    @person = person

    mail(:to => person.email, :subject => "Welcome in #{host}")
  end

  private
  def host
    Rails.configuration.action_mailer.default_url_options[:host]
  end
end

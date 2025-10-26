class UserMailer < ApplicationMailer
  def import_finished(user)
    @user = user
    mail(to: @user.email, subject: I18n.t("mailers.user_mailer.import_finished.subject"))
  end
end

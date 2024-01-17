class ApplicationMailer < ActionMailer::Base
  self.deliver_later_queue_name = 'mailers'
  default from: "from@example.com"
  layout "mailer"

end
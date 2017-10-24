class Mailer
  attr_reader :from, :to, :subject, :body

  def initialize(from, to, subject, body)
    @from = from
    @to = to
    @subject = subject
    @body = body
  end

  def send
    mail = create_email
    mail.deliver!
  end

  private

    def create_email
      Mail.new do
        from     @from
        to       @to
        subject  @subject

        text_part do
          body @body
        end

        html_part do
          content_type 'text/html; charset=UTF-8'
          body @body
        end
      end
    end
end

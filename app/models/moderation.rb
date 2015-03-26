class Moderation < ActiveRecord::Base
  belongs_to :moderator,
    :class_name => "User",
    :foreign_key => "moderator_user_id"
  belongs_to :story
  belongs_to :comment
  belongs_to :user

  after_create :send_message_to_moderated

  def send_message_to_moderated
    m = Message.new
    m.author_user_id = self.moderator_user_id

    # mark as deleted by author so they don't fill up moderator message boxes
    m.deleted_by_author = true

    if self.story
      m.recipient_user_id = self.story.user_id
      m.subject = I18n.t('models.moderation.moderated_message_subject')
      m.body = I18n.t('models.moderation.moderated_message_body1', story: self.story.title, url: self.story.comments_url, changes: self.action )

      if self.reason.present?
        m.body << I18n.t('models.moderation.moderated_message_body2', reason: self.reason )
      end

    elsif self.comment
      m.recipient_user_id = self.comment.user_id
      m.subject = I18n.t('models.moderation.moderated_comment_subject')
      m.body = I18n.t('models.moderation.moderated_comment_body1', story: self.comment.story.title, url: self.comment.story.comments_url, comment: self.comment.comment )

      if self.reason.present?
        m.body << I18n.t('models.moderation.moderated_comment_body2', reason: self.reason )
      end

    else
      # no point in alerting deleted users, they can't login to read it
      return
    end

    m.body << I18n.t('models.moderation.automated_message')

    m.save
  end
end

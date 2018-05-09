# == Schema Information
#
# Table name: questions
#
#  id                         :integer          not null, primary key
#  quiz_id                    :integer
#  text                       :text
#  priority                   :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#  hint                       :string
#  comment                    :text
#  sample                     :boolean          default(FALSE)
#  study_guide                :text
#  study_guide_attachment     :string
#  attachment                 :string
#  latex                      :boolean          default(FALSE)
#  question_guide_pdf_preview :string
#  guide_filename             :string
#
# Indexes
#
#  index_questions_on_quiz_id  (quiz_id)
#

class Question < ActiveRecord::Base

  has_many :answers, dependent: :destroy
  # has_one  :correct_answer, :class => 'Answer'
  belongs_to :quiz, :touch => true

  validates :text, :presence => true, unless: ->(user) { user.attachment.present? }
  validates :attachment, presence: true, unless: ->(user){ user.text.present? }

  validate :number_of_answers, :one_correct_answer

  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :answers, allow_destroy: true

  before_create :set_priority

  mount_uploader :study_guide_attachment, ::QuestionGuideUploader
  mount_uploader :attachment, ::MaterialUploader
  mount_uploader :question_guide_pdf_preview, ::QuestionGuidePreviewUploader

  def question_number
    count = 1
    self.quiz.present? && self.quiz.questions.present? && self.quiz.questions.each do |question|
      if self.id == question.id
        return count
      else
        count = count + 1
      end
    end
  end

  def as_json(options={})
    if options[:request_type] == "question"
      self.reload
      {
        :quiz_id => self.quiz_id,
        :text =>  self.text,
        :latex => self.latex,
        :priority =>  self.priority,
        :id =>  self.id,
        :created_at =>  self.created_at,
        :updated_at =>  self.updated_at,
        :hint =>  self.hint,
        :sample => self.sample,
        :question_number => self.question_number,
        :comments => self.comments.order('id'),
        :study_guide_attachment_url => self.study_guide_attachment_url,
        :study_guide => self.study_guide,
        :question_guide_pdf_preview_url => self.question_guide_pdf_preview.url,
        :guide_filename => self.guide_filename,
      }
    else
      self.reload
      {
        :quiz_id => self.quiz_id,
        :text =>  self.text,
        :latex => self.latex,
        :attachment_url => self.attachment_url,
        :priority =>  self.priority,
        :id =>  self.id,
        :comment =>  self.comment,
        :created_at =>  self.created_at,
        :updated_at =>  self.updated_at,
        :hint =>  self.hint,
        :sample => self.sample,
        :answers =>  self.answers,
        :question_number => self.question_number,
        :comments => self.comments.order('id'),
        :study_guide_attachment_url => self.study_guide_attachment_url,
        :study_guide => self.study_guide,
        :question_guide_pdf_preview_url => self.question_guide_pdf_preview.url,
        :guide_filename => self.guide_filename,
      }
    end
  end

  def to_s
    text
  end

  def change_order(move)
    if move > 0
      below = self.class.where("quiz_id = ? AND priority < ?", self.quiz_id, self.priority)
        .order('priority DESC').first
      if below.present?
        below.increment(:priority).save
        self.decrement(:priority).save
      end
    else
      above = self.class.where("quiz_id = ? AND priority > ?", self.quiz_id, self.priority)
        .order('priority ASC').first
      if above.present?
        above.decrement(:priority).save
        self.increment(:priority).save
      end
    end
  end

  private

    def number_of_answers
      errors.add(:base, "You must provide at least two answers") if answers.size < 2
    end

    def one_correct_answer
      if answers.to_a.reject{|a| a.marked_for_destruction?}.count(&:correct) != 1
        errors.add(:base, "(Only) One answer must be correct")
      end
    end

    def set_priority
      self.priority = (self.class.where("quiz_id = ?", self.quiz_id).maximum(:priority) || 0) + 1
    end

end

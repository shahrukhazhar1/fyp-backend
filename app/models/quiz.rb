# == Schema Information
#
# Table name: quizzes
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  subject                :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  status                 :integer          default(0)
#  topic                  :string(255)
#  description            :text
#  position               :integer
#  row_order              :integer
#  passing_percentage     :integer
#  quiz_user_id           :integer
#  quiz_status            :string(255)
#  study_guide_text       :text
#  study_guide_comment    :text
#  approval_date          :datetime
#  approved_by            :string(255)
#  test_prep              :string(255)
#  attachment             :string(255)
#  supplement_text        :text
#  quiz_guide             :text
#  quiz_guide_attachment  :string(255)
#  supplement_pdf_preview :string(255)
#  quiz_guide_pdf_preview :string(255)
#  supplement_filename    :string(255)
#  guide_filename         :string(255)
#  course_id              :integer
#
# Indexes
#
#  index_quizzes_on_course_id     (course_id)
#  index_quizzes_on_quiz_user_id  (quiz_user_id)
#

class Quiz < ActiveRecord::Base
  include RankedModel
  ranks :row_order
  has_many :questions, -> { order(:priority) }
  has_many :quiz_selections, :dependent => :destroy
  has_many :devices, :through => :quiz_selections

  belongs_to :quiz_user
  belongs_to :course

  # belongs_to :grade

  has_many :quiz_grades, dependent: :destroy
  has_many :grades, through: :quiz_grades

  enum :status => [:awaiting_approval, :approved, :rejected]

  validates :name, :presence => true

  after_touch :touch_devices
  after_save :touch_devices

  after_create :set_quiz_status

  has_many :comments, dependent: :destroy

  mount_uploader :attachment, ::MaterialUploader

  mount_uploader :quiz_guide_attachment, ::MaterialUploader

  mount_uploader :supplement_pdf_preview, ::QuizPdfPreviewUploader

  mount_uploader :quiz_guide_pdf_preview, ::QuizPdfPreviewUploader

  # question_guide_pdf_preview

  SORT_BY = ["Relevance","Newest", "Subject", "Topic", "Quiz Name"]

  def set_quiz_status
    self.update_column(:quiz_status, "incomplete")
  end

  def to_s
    name
  end

  def self.quiz_queue_search(search)
    if search.present?
      subject = search[:subject].present? ? "%#{search[:subject]}%" : nil
      quizzes = self.where('name ilike ? OR subject ilike ?',"%#{search[:q]}%", subject )
      if search[:grade_ids].present?
        quizzes = quizzes.where(grade_id: search[:grade_ids])
      elsif search[:subject_ids].present?
        quizzes = quizzes.where(id: search[:subject_ids])
      end
      quizzes
    else
      all
    end
  end

  def self.quiz_with_status(status,search)
    approved_quizzes = self.where('quiz_status = ?',status)
    if search.present?

      subject = search[:name].present? ? "%#{search[:name]}%" : nil
      quizzes = approved_quizzes.where('name ilike ? OR subject ilike ?',"%#{search}%", subject)

      if quizzes.blank?
        quizzes = approved_quizzes
      end
      if search[:grade_id_eq].present?
        # quizzes = quizzes.where(grade_id: search[:grade_id_eq])
      elsif search[:subject_ids].present?
        quizzes = quizzes.where(id: search[:subject_ids])
      end
    else
      quizzes = approved_quizzes
    end
    quizzes
  end

  def self.search(search)
    approved_quizzes = self.where('quizzes.quiz_status = ?','approved')
    if search.present?
      if search[:q].present?
        grades_list = Grade.where('grades.name ilike ? ', "%#{search[:q]}%")

        if grades_list.present?
          grade_quizzes = approved_quizzes.joins(:grades).where('grades.id IN (?)', grades_list.select(:id))
        end

        quizzes = where('quizzes.name ilike ? OR quizzes.description ilike ? OR quizzes.test_prep ilike ? OR quizzes.subject ilike ? OR quizzes.topic ilike ?  AND quizzes.quiz_status = ?', "%#{search[:q]}%", "%#{search[:q]}%", "%#{search[:q]}%" ,"%#{search[:q]}%", "%#{search[:q]}%" , 'approved' )

        if grade_quizzes.present?
          result = quizzes + grade_quizzes
          result.map{|i| i.id}
          quizzes = approved_quizzes.where(id: result).uniq
        end
      end

      if search[:subject].present?
        quiz_obj = Quiz.find_by_id search[:subject]
        quiz_sub = quiz_obj.try(:subject)
        if quiz_sub.present?
          quiz_sub = "%#{quiz_sub}%"
        end
        quizzes ||= approved_quizzes
        quizzes = quizzes.where('quizzes.subject ilike ? AND quizzes.quiz_status = ?', quiz_sub, 'approved')
      end

      if search[:grade_ids].present?
        quizzes ||= approved_quizzes
        quizzes = quizzes.joins(:grades).where(grades: {id: search[:grade_ids]}).uniq
      end

      if search[:subject_ids].present?
        quiz_records = Quiz.where(id: search[:subject_ids])
        subject_arr = quiz_records.collect(&:subject)
        quizzes ||= approved_quizzes
        quizzes = quizzes.where(quiz_status: 'approved', subject: subject_arr)
      end

      if search[:test_preps].present?
        quizzes ||= approved_quizzes
        quizzes = quizzes.where(test_prep: search[:test_preps])
      end
      quizzes
    else
      quizzes = approved_quizzes
    end
    quizzes
  end

  def as_json(options={})
    self.reload
    {
      :quiz_user_name    => self.quiz_user.try(:email),
      :name                =>  self.name,
      :id                  =>  self.id,
      :created_at          =>  self.created_at,
      :topic          =>  self.topic,
      :description          =>  self.description,
      # :attachment_url    => self.attachment_url,
      :supplement_text => self.supplement_text,
      # :position          =>  self.position,
      :passing_percentage          =>  self.passing_percentage,
      :quiz_user_id          =>  self.quiz_user_id,
      :quiz_status          =>  self.quiz_status,
      :study_guide_text          =>  self.study_guide_text,
      # :study_guide_comment          =>  self.study_guide_comment,
      :approval_date          =>  self.approval_date,
      :approved_by          =>  self.approved_by,
      # :test_prep          =>  self.test_prep,
      # :row_order          =>  self.row_order,
      :grades         =>  self.grades.collect(&:name),
      :questions         =>  self.questions,
      :default_question => Question.first.text,
      :first_question         =>  self.questions.try(:first),
      # :comments => self.comments.order('id'),
      # :quiz_guide_attachment_url => self.quiz_guide_attachment_url,
      # :quiz_guide => self.quiz_guide,
      # :quiz_guide_attachment_preview => self.quiz_guide_pdf_preview.url,
      # :supplement_pdf_preview => self.supplement_pdf_preview.url,
      # :supplement_filename => self.supplement_filename,
      # :guide_filename => self.guide_filename,
      :course_id  =>  self.course_id,
      :course_name => self.course.try(:name)

    }
  end

  private
    def touch_devices
      self.devices.update_all :updated_at => Time.now
    end
end

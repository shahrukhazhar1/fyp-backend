# == Schema Information
#
# Table name: quiz_results
#
#  id                 :integer          not null, primary key
#  device_id          :integer
#  quiz_selection_id  :integer
#  correct            :integer          default([]), is an Array
#  wrong              :integer          default([]), is an Array
#  created_at         :datetime
#  updated_at         :datetime
#  passed             :boolean          default(FALSE)
#  passing_percentage :integer
#  passing_val        :integer
#  quiz_user_id       :integer
#
# Indexes
#
#  index_quiz_results_on_device_id          (device_id)
#  index_quiz_results_on_quiz_selection_id  (quiz_selection_id)
#

class QuizResult < ActiveRecord::Base

  belongs_to :device
  belongs_to :quiz_user
  belongs_to :quiz_selection
  after_create :decide_result
  has_one :quiz, through: :quiz_selection

  def quiz_selection
    QuizSelection.unscoped{ super }
  end

  def quiz
    quiz_selection.quiz
  end

  def compile_result
    str=""
    quiz_selection.quiz.questions.each do |q|
      str+= q.labels.collect(&:name).join(",")
      str+=","
    end
    str.split(",").uniq
  end

  scope :recent, -> { where("DATE(quiz_results.created_at) > ?", (Date.today).to_time - 7.days) }

  scope :recent_date, ->(start_date, end_date){
    where("DATE(quiz_results.created_at) >= ? AND DATE(quiz_results.created_at) <= ? ", start_date, end_date)
  }

  def get_passing_percentage
  	quiz_selection.try(:quiz).try(:passing_percentage)
  end

  def decide_result
    correct_count = self.correct.try(:size)
    wrong_count = self.wrong.try(:size)
    if correct_count.present?
      total_questions =  self.quiz_selection.try(:quiz).try(:questions).try(:count)
      total_questions = correct_count + wrong_count if total_questions == 0
      score = (correct_count.to_f/total_questions)* 100 rescue 0
      score = score.round(2)
      if score.present? && score.to_i >= get_passing_percentage
        self.passed = true
      else
        self.passed = false
      end
    else
      self.passed = false
      score = 0
    end
    self.passing_percentage = score
    self.passing_val = self.passing_percentage
    self.save!
  end

  def as_json(options={})
    self.reload
    {
      :result_labels  => self.compile_result,
      :passed                =>  self.passed,
      :id                  =>  self.id,
      :created_at          =>  self.created_at,
      :updated_at          =>  self.updated_at,
      :quiz_name            => self.quiz_selection.quiz.name
    }
  end

end

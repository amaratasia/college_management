class Score < ApplicationRecord
  belongs_to :exam
  belongs_to :subject
  belongs_to :user

  scope :semester_ilike,  ->(semester)    { where("#{self.to_s.downcase.pluralize}.semester = ?", semester)  if semester.present? }


  def department
  	self.subject.department
  end
end

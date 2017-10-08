class Score < ApplicationRecord
  belongs_to :exam
  belongs_to :subject
  belongs_to :user

  scope :semester_is,  ->(semester)    { where("#{self.to_s.downcase.pluralize}.semester = ?", semester)  if semester.present? }
  scope :batch_is,     ->(batch)    { joins(:user).where('year_of_adm = ?', batch.to_i) if batch.present? }

  def department
  	self.subject.department
  end
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :registerable,
         :rememberable, :trackable, :validatable

  has_many :absences
  has_many :events

  validates :name, presence: true

  scope :in_vacation, (lambda do
    joins(:vacations)
      .where('vacations.start_date <= :today AND vacations.end_date >= :today', today: Time.zone.today)
  end)

  def self.birthdays_of_this_week
    select do |user|
      user.birthday? && (Time.zone.today..Time.zone.today + 6).cover?(user.birthday.change(year: Time.zone.now.year))
    end
  end

  def fullname
    [name, surname].join(' ')
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  surname                :string
#  birthday               :date
#  location               :string
#  github_login           :string
#  gravatar_url           :string
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

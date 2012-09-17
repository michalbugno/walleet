class Person < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  validates :email, :format => {:with => /\A[^@]+@[^@]+\z/, :message => "Email has wrong format"}, :uniqueness => {:message => "Email is already taken"}
  validates :password, :length => {:minimum => 4, :message => "Password is too short"}

  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :group_memberships
  has_many :persons, :through => :group_memberships
  has_many :groups, :through => :group_memberships, :conditions => {:visible => true}, :order => "groups.created_at DESC"

  before_create :generate_api_token

  def related_people
    group_ids = GroupMembership.
      where(:person_id => self.id).
      select("DISTINCT(group_id)").
      map(&:group_id)

    people_ids = GroupMembership.
      where(:group_id => group_ids).
      where("person_id IS NOT NULL").
      where("person_id != ?", self.id).
      select("DISTINCT(person_id)").
      map(&:person_id)

    Person.where(:id => people_ids)
  end

  def related_memberships
    group_ids = GroupMembership.
      where(:person_id => self.id).
      select("DISTINCT(group_id)").
      map(&:group_id)

    GroupMembership.
      where(:group_id => group_ids)
  end

  def send_invitation
    generate_reset_password_token!
    Mailer.invitation(self).deliver
  end

  def generate_api_token
    self.api_token = SecureRandom.hex(10)
  end
end

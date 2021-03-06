class Driver
  include Mongoid::Document
  include ActiveModel::SecurePassword
  
  field :first_name, type: String
  field :middle_init, type: String
  field :last_name, type: String
  field :phone, type: Integer
  field :email, type: String
  field :trained, type: Mongoid::Boolean
  field :blacklist, type: Array, default: []
  field :password_digest, type: String
  
  embeds_many :schedule
  accepts_nested_attributes_for :schedule
  
  has_secure_password
  belongs_to :admin
  has_many :appointments
  
  def self.blacklist_reset
    Driver.each do |driver|
      to_del = []
      driver.blacklist.each do |bl|
        appt = Appointment.find(bl) rescue nil
        if appt.nil?
          to_del.append(bl)
        elsif DateTime.strptime(appt.datetime, '%Y-%m-%d %H:%M').to_date.past?
          to_del.append(bl)
        end
      to_del.each do |d|
        driver.blacklist.delete(d)
      end
      driver.save
      end
    end
  end
end
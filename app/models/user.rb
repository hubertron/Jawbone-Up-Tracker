class User < ActiveRecord::Base


  def self.find_or_create_jawbone_user(token)
    jawbone_profile = JawboneUp.new.profile(token)
    user = User.where(:up_user_xid => jawbone_profile.xid).first
    if user.blank?
      User.create_user_from_jawbone(profile:jawbone_profile, token:token)
    else
      user.update_jawbone_profile(profile: jawbone_profile, token:token)
    end
  end

  def update_jawbone_profile(profile:nil, token:nil)
    return nil if profile.nil?
    self.update_attributes(user_attributes(profile:profile, token:token))
    self
  end

  def self.create_user_from_jawbone(profile:nil, token:nil)
    return nil if profile.nil?
    User.create(user_attributes(profile:profile, token:token))
  end

  def self.user_attributes(profile:nil, token:nil)
    {
      :first_name      => profile.first_name,
      :last_name       => profile.last_name,
      :up_user_xid     => profile.xid,
      :up_access_token => token,
      :up_image        => profile.image_url
    }
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def avatar
    "http://jawbone.com/#{self.up_image}"
  end
end

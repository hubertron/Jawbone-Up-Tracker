class User < ActiveRecord::Base

  def self.find_or_create_jawbone_user(token)
    user = User.where(:up_access_token => token).first
    puts "USER:#{user.inspect}"
    if user.blank?
      jawbone_profile = JawboneUp.new.profile(token)
      unless jawbone_profile.blank?
	User.create( :first_name      => jawbone_profile.first_name,
		     :last_name       => jawbone_profile.last_name,
		     :up_user_xid     => jawbone_profile.xid,
		     :up_access_token => token,
		     :up_image        => jawbone_profile.image_url)

      end
    else
      user
    end
  end
end

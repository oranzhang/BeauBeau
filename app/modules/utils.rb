# -*- coding:utf-8 -*-
module Mforum
end
module Mforum::Helpers
	module Post
		def get_reply_list(id)
			Reply.where(belong_to: id)
		end
		def get_topic_user(id)
			MongoidUser.where(name: Topic.where(_id: id)[0].user)[0]
		end
	end
	module Setties
		def get_db_settings(id)
			@s = Setting.where(title: id)
			if @s.exists?
				@s[0].data
			else
				false
			end
		end
		def admin?
			$admins.include?(current_user.email)
		end
		def admin_zone
			if $admins.include?(current_user.email) != true
				redirect "/"
			end
		end
	end
end
helpers Mforum::Helpers::Post , Mforum::Helpers::Setties
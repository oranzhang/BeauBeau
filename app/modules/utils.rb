module Mforum
end
module Mforum::Helpers
	module Post
		def get_reply_list(id)
			Reply.where(belong_to: id)[0]
		end
		def get_topic_user(id)
			MongoidUser.where(name: Topic.where(_id: id)[0].user)[0]
		end
	end
end
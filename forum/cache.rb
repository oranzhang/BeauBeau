class Cache
	def initialize
		@posts = Post.where(type:"reply")
		@cached_list_all = Array.new
		@posts.sort(_id: -1).each do |post|
			if post != nil
				@cached_list_all << post.mother
			end
		end
		@cached_list_all = @cached_list_all.uniq
		@cached_list_node = {}
		Node.each do |n|
			@cached_list_node[n.name] = Array.new
			@posts.where(node: n.name).sort(_id: -1).each do |post|
				if post != nil
					@cached_list_node[n.name] << post.mother
				end
			end
			@cached_list_node[n.name] = @cached_list_node[n.name].uniq
		end
	end
	def update
		@posts = Post.where(type:"reply")
		@cached_list_all = Array.new
		@posts.sort(_id: -1).each do |post|
			if post != nil
				@cached_list_all << post.mother
			end
		end
		@cached_list_all = @cached_list_all.uniq
		@cached_list_node = {}
		Node.each do |n|
			@cached_list_node[n.name] = Array.new
			@posts.where(node: n.name).sort(_id: -1).each do |post|
				if post != nil
					@cached_list_node[n.name] << post.mother
				end
			end
			@cached_list_node[n.name] = @cached_list_node[n.name].uniq
		end
	end
	def getcachedlist(node="")
		if node == ""
			@return = @cached_list_all
		else
			@return = @cached_list_node[node]
		end
		return @return
	end
end
$post_cache = Cache.new
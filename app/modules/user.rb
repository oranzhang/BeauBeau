# -*- coding:utf-8 -*-
#modules/user
module UserUtils
	def CreatUser(iname,ipass,imail)
		if User.where(name: iname).exists?
			@msg = 'name_exists' #name exists
		else
			 if User.where(mail:imail).exists?
				@msg = 'email_exists'  #Email exists => msg = 2
			else 
				User.create(
					name: iname,
					pass: Digest::SHA1.hexdigest(ipass),
					mail: imail,
					regtime: Time.now(),
					status: "user",
					more: ""
					) 
				@msg = '{"msg":0}'  #Su => 0
			end
		end
		return @msg
	end	
	def Login(iname,ipass)
		if User.where(name: iname,pass:Digest::SHA1.hexdigest(ipass)).exists?
			@ck = Hash["name",iname,"mail",Digest::MD5.hexdigest(User.where(name: iname,pass:Digest::SHA1.hexdigest(ipass))[0].mail)]
			@ck_json = @ck.to_json
			session["auth"] = @ck_json
			@msg = true#succ
		else
			@msg = false #incorrent
		end
		return @msg
	end
	def Logined?
			@msg = true
			if cookies["auth"] == nil
				@msg = false
			end
			if cookies["auth"] == ""
				@msg = false
			end
			return @msg
	end
end
get "/user/reg" do
	slim :user_reg 
end
post "/user/reg" do
	point = CreatUser(params[:name],params[:password],params[:mail])
	"#{point+params[:name]+params[:password]+params[:mail]}"
end
get "/user/login" do
	slim :user_login 
end
post "/user/login" do
	point = Login(params[:name],params[:password])
	"#{point}#{params[:name]}#{params[:password]}#{session[:auth].to_s}"
end


use Rack::Session::EncryptedCookie,
	:secret => settings.config["key"]
if development?
	get "/test/cookies/:foo" do
		"#{session[params[:foo]]}"
	end
	get "/test/cookies/:foo/:bar" do
		session[params[:foo]] = params[:bar]
	end
end
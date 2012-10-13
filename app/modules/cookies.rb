use Rack::Session::EncryptedCookie,
	:secret => settings.config["key"]

# -*- coding:utf-8 -*-
use Rack::Session::Cookie,
	:secret => settings.config["key"]
use Rack::Flash

Mforum
======
A light wight forum applocation . Based on Ruby & Sinatra & MongoDB.
Lively Development & Support by Meence Team (http://meence.com)  

**The app is on development and not finished , and it can not be for using yet.**

Requirement : 
- **Unix/Unix-Like OS**(However you can use Mforum in Windows if you can make `eventmachine` gem works in Windows)
- Ruby 1.9+ , MongoDB 1.7+


Install
======
- `git clone https://github.com/oranzhang/Mforum.git`
- `cd Mforum/forum`
- `cp config/config.eg.json forum/config/config.json`
- `cp config/mongoid.eg.yml forum/config/mongoid.yml`
-  And then you need to edit `config.json` and `mongoid.yml`.
- `bundle install`
- `ruby ./forum.rb` or `rackup`

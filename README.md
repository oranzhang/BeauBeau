Mforum
======
A light wight forum applocation . Based on Ruby & Sinatra & MongoDB.
Lively Development & Support by Meence Team (http://meence.com)  

**The app is on development and not finished , and it can not be for using yet.**

- System Required : Unix/Unix-Like OS , Ruby 1.9+ , MongoDB 1.7+
- Gems required : `sinatra`,`sinatra-contrib`,`markdown`,`mongoid`,`json`,`aes`


Install
======
- `gem install sinatra sinatra-contrib markdown mongoid json aes`
- `git clone https://github.com/oranzhang/Mforum.git`
- `cd Mforum`
- `cp forum/config/config.eg.json forum/config/config.json`
- `cp forum/config/mongoid.eg.yml forum/config/mongoid.yml`
- And then you need to edit these two file.
- `cd forum`
- `ruby ./forum.rb`

# Final Year Project: Cyber Security e-learning platform
- Niall Canning 
- URN: nc00627

## Deployed web application using ROR & Heroku
![image](https://github.com/niallc18/cyberlearn/assets/109161441/6c2f0a07-f09d-4e73-b524-a51674232298)


- URL: https://cyberlearnv1.herokuapp.com/
- For access to admin, teacher, and student accounts, please contact me, as this application is specifically built for a university final year project, and not for public use.
## Usage Instructions

- Create AWS Cloud 9 account
- Install Rails 6 and Ruby 2.7.2
- Install Postgresql & Yarn for the database

 Run following commands in terminal for installing Ruby, Yarn, and postgresql:
 ```
rvm install ruby-2.7.2
gem install rails -v 6.1.0
rvm --default use 2.7.2
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install postgresql libpq-dev redis-server redis-tools yarn
 
 ```
- Clone the repository or upload files to AWS account
 
 Install gems and packages:

```

cd cyberlearn
bundle
yarn

```
- Edit credentials file "credentials.ymc.enc" by using the following command and inserting AWS keys and recaptcha keys
```
EDITOR=vim rails credentials:edit
i
:wq

```

- Setup Postgresql

Run these commands to setup the postgresql account as a superuser.

```
sudo su postgres
createuser --interactive
ubuntu

```

- Now start the server by creating and running all migrations

```

rails db:create
rails db:migrate
rails s

```
- May also need to change configuration file and change host address and region according to your AWS account setup.
- Contact niallftw18@gmail.com for any help with setup.

## Testing instructions

- Once the application is setup, use the following commands to run all the tests using Rspec gem.

```
cd /cyberlearn/spec
rails spec

```

## References

### The following GitHub repos helped a lot in building this application, and are linked below and throughout the source code.

- https://github.com/corsego/corsego/tree/main/app
- https://github.com/learnenough/rails_tutorial_sample_app_7th_ed
- https://github.com/bc2mighty/Rails-Project-Management-App 
- Also special thanks to my supervisor for continously helping me with this project throughout the year!

### Following gems used within this project, and more included in the gemfile.
- https://github.com/rspec/rspec-rails
- https://github.com/varvet/pundit
- https://github.com/RolifyCommunity/rolify
- https://github.com/heartcombo/simple_form
- https://github.com/activerecord-hackery/ransack
- https://github.com/bokmann/font-awesome-rails
- https://github.com/norman/friendly_id
- https://github.com/brendon/ranked-model




# README

A minimal pizza management web app, created for a software engineering exercise.

## Running locally

The following was done to set up a local Ubuntu environment to develop and run the application.

- Install the version of Ruby specified in `.ruby-version`.
	- Run `sudo apt-get update`
	- Run `sudo apt install build-essential rustc libssl-dev libyaml-dev zlib1g-dev libgmp-dev`
	- Install a Ruby version manager. I used RVM since that's what I'm familiar with. Run the following to install RVM:s
		- `sudo apt-get install software-properties-common`
		-	`sudo apt-add-repository -y ppa:rael-gc/rvm`
		-	`sudo apt-get update`
		-	`sudo apt-get install rvm`
		- `sudo usermod -a -G rvm $USER`
	- `rvm install ruby-3.2.2`

- Install and configure postgres
	- Run `sudo apt update` and then `sudo apt install postgresql postgresql-contrib libpq-dev`
	- Start the database with `sudo service postgresql restart`.
	- Create a PSQL user for the app to use with `sudo -u postgres createuser -s pizza_admin -P`.
	- Create a .env file in the application's main directory. Modify this file to include entries for `DEV_DB_USERNAME` and `DEV_DB_PASSWORD` that correspond to the username and password you provided for the PSQL user.
	- Log in as the new user with `psql -U pizza_admin` and run `SHOW hba_file;` to get the path to the `pg_hba.conf`.
	- Navigate to the `pg_hba.conf` file. Replace the line
	`local   all             all                                     peer`
	with
	`local   all             all                                     md5`
	Also replace the line
	`local   replication     all                                     peer`
	with
	`local   replication     all                                     md5`
- Clone the application and switch it's directory.

- Install gems
	- Run `gem install bundler`
	- Run `bundle install`

- Load the app's data into the database
	- Run `rake db:migrate`
	- Run `rails db:fixtures:load` to populate the database,

The application can then be ran locally with
`rails server`

The application's tests can be ran with
`rails test`

## Implementation choices

For the most part, this is just a minimal Ruby on Rails application, though [simple.css](https://github.com/kevquirk/simple.css) was used to style the application. This was largely done for the sake of expediency. Were this is a longer term project, it would be more appropriate to choose a larger and more robust toolset.

### Data model

Authorization was not a requirement of the exercise, though it was required that there be a role system. Hence, the minimal `User` and `Role` models lack some common fields like usernames and passwords.

The `User` model was permitted to have multiple `Roles` as the two provided roles, a store owner and a pizza chef, did not seem mutually exclusive.

The `Topping` and `Pizza` model contain fields for their price, calories, and whether or not they are vegetarian as I was instructed to determine what information was important. Vegetarian is included on the `Pizza` model to allow the model to represent vegetarian and non-vegetarian pizza bases. Price was implemented as an integer to avoid issues due to floating point imprecision.

These fields were not tightly defined in terms of permitted values as they were, functionally, guesses. Realistically, I would want to iterate with the end user on what information they wanted and what information made sense in their context.

The `Pizza` model was permitted to be associated with multiple instances of the same `Topping`. This was done to represent pizzas that had extra of a topping.

Per the requirements, duplicate `Topping` and `Pizza` objects were not allowed. In both cases, it was decided that this should mean the names of the objects should be unique as the same name for technically different toppings or pizzas would be confusing. For `Pizzas`, it was also decided that each one needed to have a unique combination of toppings as having multiple functionally identical pizzas with different names seemed confusing. `Toppings` were allowed to have duplicate values since, feasibly, multiple different toppings could have the same price, caloric content, etc.

### Frontend

The frontend was kept simple and functional for the sake of expediency, though effort was made to keep it clean and readable.

Making the application responsive to different devise sizes was deprioritized as the requirements suggested this was a stretch goal.

### Testing

The application only made use of the testing tools that come packaged with Rails for the sake of expediency. Thorough testing of the `Pizza` and `Topping` models, controllers, and views were prioritized as they were the focus of the requirements and the `User` and `Role` system was implemented largely just to facilitate testing.

Despite the requirements suggesting that testing was somewhat of a stretch goal, testing was still implemented as I found it useful to ensure I understood and had correctly implemented the requirements.

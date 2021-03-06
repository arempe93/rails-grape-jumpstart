Rails Grape Jumpstart
=====================

A basic starting point for [Grape APIs](https://github.com/ruby-grape/grape) running on Rails.

## Installation

#### 1. Clone the boilerplate

```
git clone --depth=1 git@github.com:arempe93/grape-rails-boilerplate.git myproject
cd myproject

git commit --amend -m "initial boilerplate commit"
git remote remove origin
```

#### 2. Change application configs

TODO comments have been placed where changes need to be made

```
rake notes
```

#### 3. Setup local environment

```
rake setup
```

## Features

Goodies included besides setting up the inital Grape mounting

#### Request ID Middleware

Includes an `X-Request-ID` header to each response

#### Logging Middleware

Includes custom middleware to log every request in the following format

```
[EjBHdKe1BK4XW7Hg]
[EjBHdKe1BK4XW7Hg] Started GET '/api/example'
[EjBHdKe1BK4XW7Hg] Processing by API::Example/example
[EjBHdKe1BK4XW7Hg]   Parameters: {}
[EjBHdKe1BK4XW7Hg] Completed 200 in 3.21ms
[EjBHdKe1BK4XW7Hg]
```

_`EjBHdKe1BK4XW7Hg` is the id of the request_

#### Error Handling

Normally, whenever your api has an uncaught error, Rails will take over and serve up a 500 with the standard template it uses based on the environment. This can be problematic because it provides clients expecting JSON no indication of what the error might be and it also, depending on your setup, could not be included in the Grape CORS policy. This can cause clients to give unhelpful error messages for the request.

The standard response the middleware will return for any uncaught exception is as follows

```javascript
{
  "message": "Something bad has happened",
  "source": "/path/to/file:100"
}
```

This format is entirely confiugrable in `app/api/base.rb`.

#### 404 Handling

Handles 404 as well, instead of letting Rails take over with a `RoutingError`. This also avoids some of the problems described above. This can be configured in `app/api/base.rb`

#### API Reloading

Automatically reloads changes to Grape API files in development. Thanks to the [Grape README](https://github.com/ruby-grape/grape#reloading-api-changes-in-development).

#### Swagger API Documentation

Comes bundled with [Swagger](http://swagger.io/) for API documentation through the help of [grape-swagger](https://github.com/ruby-grape/grape-swagger) and [grape-swagger-rails](https://github.com/ruby-grape/grape-swagger-rails). You can configure the documentation title and options in `config/initializers/swagger.rb`

#### Route Printing

Run `rake grape:routes` to print all routes for the application, similar to `rake routes` in plain Rails

#### CORS Configuration

Adds CORS configuration on `/api/` in `config/initializers/cors.rb` using `Rack::CORS`. The default is any origin, any method.

#### API Error Helpers

Gives aliases to Grape's `error!` method, for readability. For example, compare writing this

```ruby
error!({ code: '404.12', message: 'User was not found' }, 404)
```

to writing something a little more quickly understandable

```ruby
not_found! message: 'User was not found', code: '404.12'
```

#### Automatic Model Annotation

Makes use of the [annotate gem](https://github.com/ctran/annotate_models) to give helpful schema annotation comments above your Rails models automatically, whenever `rake db:migrate` is run

```ruby
# == Schema Information
#
# Table name: messages
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  feed_id       :integer
#  feed_sequence :integer
#  message_type  :integer
#  payload       :string
#  options       :hstore
#  sent_at       :datetime
#
# Indexes
#
#  index_messages_on_feed_id  (feed_id)
#  index_messages_on_user_id  (user_id)
#

```

#### Enumeration Support

An autoloaded directory `app/enums` has been included to support enums, specifically [EnumerateIt enums](https://github.com/cassiomarques/enumerate_it): the best gem I have found for Ruby/Rails enums.

I find that enumerations and Grape APIs work very well together, especially for validation and entities.

```ruby
desc 'An enum validation example'
params do
  optional :foo_type, type: Integer, values: Enums::FooType.list
end
```

#### Global Configuration

I find the [global](https://github.com/railsware/global) gem helpful for storing environment specific application configurations

### Helpers

Plenty of helpers in `app/api/support`

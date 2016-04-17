[![Gem Version](https://badge.fury.io/rb/omnidesk_auth.svg)](https://badge.fury.io/rb/omnidesk_auth)
[![Build Status](https://travis-ci.org/justCxx/omnidesk_auth.svg?branch=master)](https://travis-ci.org/justCxx/omnidesk_auth)
[![Code Climate](https://codeclimate.com/github/justCxx/omnidesk_auth/badges/gpa.svg)](https://codeclimate.com/github/justCxx/omnidesk_auth)
[![Test Coverage](https://codeclimate.com/github/justCxx/omnidesk_auth/badges/coverage.svg)](https://codeclimate.com/github/justCxx/omnidesk_auth/coverage)

# OmnideskAuth

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omnidesk_auth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omnidesk_auth

## Usage

### Rails

#### Configure

```ruby
# config/initializers/omnidesk_auth.rb
OmnideskAuth.configure do |auth|
  auth.endpoint = 'http://mycompany.omnidesk.ru'
  auth.secret = '<secret token>'
end
```

Note: The OmnideskAuth module takes the configuration defaults from environment variables:

 - OMNIDESK_AUTH_SECRET
 - OMNIDESK_AUTH_ENDPOINT
 - OMNIDESK_AUTH_EXPIRE

See: [OmnideskAuth::Default](lib/omnidesk_auth/default.rb)

#### Controller
```ruby
# app/controllers/support_controller.rb
class SupportController < ApplicationController
  def omnidesk_sign_in
    redirect_to OmnideskAuth.sso_auth_url(email: current_user.email)
  end
end
```

According to the documentation omnidesk service accepts as binding the following fields:

- iat (required) - Issued At (the time when the token was generated))
- email (required) - user email

Parameter "iat" is installed automatically during the generation of the token, but is also available for self-installation via the options hash.
Parameter email is the only field that you need to be sure to pass.

Example of filling in all possible fields:

```ruby
def omnidesk_sign_in
  redirect_to OmnideskAuth.sso_auth_url(
    iat: Time.current.to_i,
    name: current_user.name,
    email: current_user.email,
    external_id: current_user.id,
    company_name: current_user.company.name,
    company_position: current_user.position,
    remote_photo_url: current_user.avatar_url,
    exp: 1.day)
end
```

See more: [Omnidesk documention](https://support.omnidesk.ru/knowledge_base/item/54180)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


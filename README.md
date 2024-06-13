# Cat Digital Backend (Ruby on Rails)

This application is designed to manage user subscriptions and notify third-party endpoints of any new or updated subscription data through webhooks.

## Table of Contents

- [Features](#features)
- [Setup](#setup)
- [Usage](#usage)


## Features

- **User Management**: Create and update user subscriptions.
- **Webhooks**: Notify third-party endpoints when subscriptions are created or updated.
- **Authenticity**: Webhook requests are authenticated using JWT tokens.

### Prerequisites

- Ruby 3.0 or later
- Rails 7.1 or later
- PostgreSQL

## Setup

To set up the project, follow these steps:

1. Clone the repository:
    ```sh
    git clone https://github.com/syed-burhan/cat_digital_backend.git
    cd cat_digital_backend
    ```

2. Install dependencies:
    ```sh
    bundle install
    ```

3. Set up the database:
    ```sh
    rails db:create
    rails db:migrate
    ```
### Configuration

Configure the third-party endpoints in `config/application.rb`:

```ruby
module CatDigitalApplication
  class Application < Rails::Application
    # Other configuration...

    # Configure third-party endpoints
    config.third_party_endpoints = [
      'https://webhook.site/your-webhook-url1',
      'https://webhook.site/your-webhook-url2'
    ]
  end
end
```

## Usage

### Running the Application
Start the Rails server:
 ```sh
    rails server
```

### Running Tests
To run the tests, use the following command:

 ```sh
    bundle exec rspec
```
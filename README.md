# Rails Universal Api

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/mabiesen/rails_universal_api)

[![CircleCI](https://circleci.com/gh/mabiesen/rails_universal_api.svg?style=svg&circle-token=9ec2448fe91308350282e35c836d082a52706af6)](<LINK>)

[![codecov](https://codecov.io/gh/mabiesen/rails_universal_api/branch/master/graph/badge.svg)](https://codecov.io/gh/mabiesen/rails_universal_api)

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/mabiesen/rails_universal_api/graphs/commit-activity)


## About

### Features of Project

Intended primarily to be run in a docker local to the project at hand, this project is designed to database accessibility of commonly used endpoints.  There are several benefits to centralizing API usage:

* troubleshooting and mapping programs
* using APIs across multiple projects without creating new clients all the time
* using APIs without involving your project in the use of libraries which may or may not receive proper upgrades/maintenance
* less potential for API credentials to be misplaced or made accessible to nefarious actors

## Ruby version

2.6.0

## Usage

## Credentials Setup

Pending a better methodology:

Check out /config/initializers/endpoint_clients.  This directory contains initializers for our endpoint clients (github, your-internal-server, etc).  Take a look at what environment variables are referenced and set them up and/or send them to the docker image at runtime.

## Local

Set up in traditional rails fashion
```
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
```

Depends on a running postgres instance, tested successfully with 10 and higher.

### Docker

To run the service in docker

```
docker-compose up --build
```

From there you should be able to hit localhost:3003/

### Available Routes

The following JSON endpoints exist for this project:

*/list_endpoints* - returns a list of endpoints
*/call/:client_tag/:request_name* - call a given endpoint
*/validate_params/:client_tag/:request_name* - validate parameters for a given endpoint
*/validate_param/:client_tag/:request_name* - validate a single param for a given endpoint, intended for use in live form validation.

#### Example - /list_endpoints
Basic example:
```
http://localhost:3000/list_endpoints
```
^^ fetches all endpoints

Example filtering for endpoints with a client_tag 'like':
```
http://localhost:3000/list_endpoints client_tag:git
```
^^ would return all endpoints with a client_tag containing the word 'git'

Example filtering for endpoints with a name 'like':
```
http://localhost:3000/list_endpoints request_name:pull
```

#### Example - /call/:client_tag/:request_name

This route is the bread and butter of the application, it is how we reach out to external endpoints (github, facebook, etc).

Basic example:
```
http://localhost:3000/call/github/get_pull_requests
```
^^ get all pull requests of any status from github

Example filtering for status:
```
http://localhost:3000/call/github/get_pull_requests state:closed
```

#### Example - /validate_params/:client_tag/:request_name

This route exists primarily as a development convenience, it provides a way to validate your parameters will work as expected.  It will also provide whollistic reivew of UI entries prior to form submission.

Basic example:
```
http://localhost:3000/validate_params/github/get_pull_requests owner:mabiesen
# would return error because repo is not supplied, but repo is not optional

http://localhost:3000/validate_params/github/get_pull_requests owner:mabiesen repo:<this_repo> stant:closed
# would return error message indicating stant is not a parameter

http://localhost:3000/validate_params/some_api_provider/some_reqeust  owner:mabiesen repo:<this_repo> date:marcus
# would return error message indicating marcus is not a date
```

#### Example(singular!) - /validate_param/:client_tag/:request_nam

Same validations as /validate_params, but only one param is supplied at a time.

Primarily intended for UI live form validation.

## Testing

from circleci cli while in home directory

```
cirlceci local execute
```

## Contributing

Steps for adding clients
1. add a /config/\<client_name\>.yml to store url information
2. add a /config/initializers/\<client_name\>.rb to initialize your client.
3. add the client to the client map in /app/models/endpoint.rb
4. environment variables consumed by the initializer should be placed in /.env.local

Steps for adding endpoints
1. rails g migration adding_some_endpoint_name
2. fill out the migration
3. run rails db:migrate RAILS_ENV=development

Versioning a new release should be done as follows:
- Patch Update - Fix application related concerns
- Minor Update - Change to an existing endpoint or client (Example: 0.7.122 -> 0.8.0)
- Major Update - New/Delete endpoint or client, route addtions  (0.7.122 -> 1.0.0)

NOTE: endpoints may not be added until a client has been added

## TODOS

#### Permissioning

TODO

Should have proper authentication.  API credentials should be stored better, presently just a .env.local file.

#### Skinny Project Templating

TODO

Some projects do not require the robustness that this service offers, and many developers prefer not to add an extra networking layer to their concerns.  A templating mechanism could be created to allow one to generate http request scripts for use in other projects.

#### UI Endpoint Execution

TODO

This UI would template out parameters in table format and offer AJAX data validation prior to data send.

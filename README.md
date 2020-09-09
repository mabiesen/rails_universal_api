# Rails Universal Api

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/mabiesen/rails_universal_api)

[![CircleCI](https://circleci.com/gh/mabiesen/rails_universal_api.svg?style=svg&circle-token=9ec2448fe91308350282e35c836d082a52706af6)](<LINK>)

[![codecov](https://codecov.io/gh/mabiesen/rails_universal_api/branch/master/graph/badge.svg)](https://codecov.io/gh/mabiesen/rails_universal_api)

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/mabiesen/rails_universal_api/graphs/commit-activity)


## About

### What are the issues this project aims to tackle?

* I want to be able to store endpoint detail in such a way that I only need to read the API documentation on rare occasion, rather than at the onset of every project.

* I want to create and store filters that can be applied to API data, to obtain only the portion of the data that you need.  Some APIs return highly complex data that requires deep thought to comprehend and access the data you need, stored filters help to DRY up this time-costly concern. 

* When I spin up a new hobby project, I want all of the API's I've previously encountered at my fingertips

* When I communicate with an API I want the transaction to be intuitive, not some combination of url interpolation and parameters.  

In short: I would like to make the developer experience of API usage/inclusion more intuitive.

### Features of Project

Intended primarily to be run in a docker local to the project at hand.

* Avoid some of the problems and limitations of gems.  Gems often lack data filtering, gems provide an additional dependency layer (gem maintainer vs. api maintainer), etc.
* use intuitively named urls to acommplish your goals.  No more concerns regarding interpolation: once the endpoint is discovered and submitted to the code base, you can strictly use traditional parameters
* there is no longer a need to worry about formatting your data as a nested object.  Data submitted as a 'flat' hash can be converted to a nested object, provided that a body_template(json template) has been supplied to the endpoint
* benefit from community contribution! As endpoints are discovered the clients and endpoints will be added to the codebase.  Filters-creation options for retrieved endpoint data coming soon.
* use the database of endpoints to generate quick scripts of endpoint calls via curl, httpie, faraday, etc. (todo, this may be tricky due to varied permissioning)
* use the UI to hit endpoints and receive real time feedback on validity (at least as regards class type expections)

## Ruby version

2.6.0

## Usage

## Credentials Setup

Pending a better methodology (coming very, very soon):

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
Basic example getting a list of all endpoints:
```
http://localhost:3000/list_endpoints
```

Example filtering for endpoints with a client_tag 'like'. The following example returns clients with a name like 'git' (ie., endpoints with 'github' client tag are returned)::
```
http://localhost:3000/list_endpoints client_tag:git
```

Example filtering for endpoints with a name 'like':
```
http://localhost:3000/list_endpoints request_name:pull
```

#### Example - /call/:client_tag/:request_name

This route is the bread and butter of the application, it is how we reach out to external endpoints (github, facebook, etc).


Example getting pull requests that are in closed status:
```
http://localhost:3000/call/github/get_pull_requests owner:mabiesen repo:rails_universal_apistate:closed
```

#### Example - /validate_params/:client_tag/:request_name

This route exists primarily as a development convenience, it provides a way to validate your parameters will work as expected. 

Basic example:
```
http://localhost:3000/validate_params/github/get_pull_requests owner:mabiesen
# would return error because repo is not supplied, but repo is not optional

http://localhost:3000/validate_params/github/get_pull_requests owner:mabiesen repo:<this_repo> stant:closed
# would return error message indicating stant is not a parameter

http://localhost:3000/validate_params/some_api_provider/some_reqeust  owner:mabiesen repo:<this_repo> date:marcus
# would return error message indicating marcus is not a date
```

#### Example(singular!) - /validate_param/:client_tag/:request_name

Same validations as you would find in /validate_params, but only one param is supplied at a time.

Primarily intended for UI live form validation.

## Testing

from circleci cli while in home directory

```
cirlceci local execute
```

## Contributing

Steps for adding clients
1. add a /config/\<client_name\>.yml to store url information
2. add a /config/initializers/endpoint_clients/\<client_name\>.rb to initialize your client. 
4. environment variables consumed by the initializer should be placed in /.env.local, or sent to docker at runtime, or however you want to handle them.

Steps for adding endpoints
1. rails g migration adding_some_endpoint_name
2. fill out the migration
3. Move the migration to db/migrate/endpoints
4. run rails db:migrate RAILS_ENV=development to see your changes locally.

NOTE: endpoints may not be added until a client has been added

## TODOS

#### DRY Data filtering

TODO

Often when API responses are received they are filtered for specific logic required for business operations.  No one needs alllllllll of the information an API like  the github pull request api provides, so often we filter for what we need at the business layer.  But because this is occuring at the business layer within an application, these common filters are not usually granted cross-project applicability.

#### Permissioning

TODO

Should have proper authentication.  API credentials should be stored better, presently just a .env.local file.

#### Skinny Project Templating

TODO

Some projects do not require the robustness that this service offers, and many developers prefer not to add an extra networking layer to their concerns.  A templating mechanism will be created to allow one to generate http request scripts for use in other projects.

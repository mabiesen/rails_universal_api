# Rails Universal Api

[![CircleCI](https://circleci.com/gh/mabiesen/rails_universal_api.svg?style=svg&circle-token=9ec2448fe91308350282e35c836d082a52706af6)](<LINK>)

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/mabiesen/rails_universal_api/graphs/commit-activity)


## About

### Reasons For Project

* one should not have remake the wheel every time they wish to make an API request in a new project(#BEDRY)
* gems are an imperfect DRY solution: updates are slow relative to new API releases, often the implementation (parsing of response etc.) causes updates to be slow, in the event of update one must attempt update in every project (often requiring other dependency updates, which may be problematic), and when gems are used there are often low level, repeated methodologies that end up getting  created in each application's business logic because there is often little incentive to dedicate time to pull request someone else's gem.

### Features of Project

#### Intuitively Named URLs

Completed

Often URLs require interpolation + parameters. This is a bit burdensome on the end user, so we are wrapping the issue such  that the end user can supply all parameters as query parameters.  All endpoints may be reached in the following manner as regards url path:
```
http http://localhost:3000/call/github/get_pull_requests
```

#### Benchmarking for API Calls

Completed 

Super simple implementation.  All calls to endpoints (if successful) will  return benchmark information indicating how long it took to validate + buildrequest + reach API endpoint.  This should be used as an understanding of system health, and against an endpoint request baseline one could determine if there is an issue with the API provider. 

#### 2D to 3D data

Completed

Often API's require three dimensional (nested) hashes, but these are difficult for the user to build.  A methodology has been created to transform 2D data to 3D data based upon a json body template.

#### DRY Data filtering

TODO

Often when API responses are received they are filtered for specific logic required for business operations.  No one needs alllllllll of the information an API like  the github pull request api provides, so often we filter for what we need at the business layer.  But because this is occuring at the business layer these common filters are not applicable across projects.

#### Dockerized

Completed 

In dockerized form, one can implement this alongside any project within-node, which may be a good implmemetation for medium sized projects.

#### Permissioning

TODO

Should have proper authentication.  API credentials should be stored better, presently just a .env.local file. 

#### Skinny Project Templating

TODO

Some projects do not require the robustness that this service offers, and many developers prefer not to add an extra networking layer to their concerns.  A templating mechanism will be created to allow one to generate http request scripts for use in other projects.

#### UI Endpoint Execution

TODO

This UI would template out parameters in table format and offer AJAX data validation prior to data send. 

## Ruby version

2.6.0

## Usage

### Docker

To run the service in docker

```
docker-compose up --build
```

From there you should be able to hit localhost:3003/

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

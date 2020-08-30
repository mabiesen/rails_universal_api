[![CircleCI](https://circleci.com/circleci/mabiesen/rails_universal_api.svg?style=svg&circle-token=9ec2448fe91308350282e35c836d082a52706af6)](<LINK>)
# Rails Universal Api

## About

Project aims to resolve the following problems frequently encountered in API usage:
* hard-coded, individually tailored ways to access an endpoint can be burdensome to update
* gems/libraries to his specific API vendors often cannot maintain pace with api updated.
* even if gems/libraries could maintain pace, there is the concern that consuming applications may need to update as methodologies become deprecated. Gems are nice insofar as they format data, but this can be done at the level of business decisioning.
* there is often unnecessary complexity in url path naming, and the combination of embedded path variables + json request can be daunting.  If the json is nested the challenge in terminal becomes greater. 

To illustrate the problem, this is the github api for pull requests:
```
https://api.github.com/repos/mabiesen/rails_universal_api/pulls + parameters
```
^^ one has to differentiate arguments to url path from arguments to parameters

----

In this project, all apis may be reached in the following manner:
```
 https://localhost:3000/call/github/get_pull_requests + parameters
```

PROJECT WISH LIST:
* authentication for users
* dockerize
* better storage of credentials
* generator to boilerplate the addition of new clients
* UI for managing endpoints
* optional filter route which can parse json for only desired fields.  Filters would be linked to endpoints.
* UI for managing filters
* mass request processing with temporary storage options

FURTHER WISHES - Gemify the concern

This is a good proof of concept but it could be made better. Could use sqlite to store endpoints, that would make this concept ingestible as a gem. Could offer a generator for rails to add to any project. 

#### Ruby version

2.6.0

#### Testing

from circleci cli while in home directory

```
cirlceci local execute
```

#### Contributing

Steps for adding clients
1. add a /config/\<client_name\>.yml to store url information
2. add a /config/initializers/\<client_name\>.rb to initialize your client.
3. add the client to the client map in /app/models/endpoint.rb
4. environment variables consumed by the initializer should be placed in /.env.local

Steps for adding endpoints
1. rails g migration adding_some_endpoint_name
2. fill out the migration
3. run rails db:migrate RAILS_ENV=development

NOTE: endpoints may not be added until a client has been added

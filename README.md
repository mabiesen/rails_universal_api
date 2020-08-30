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

# Rails Universal Api

## About

Project aims to reduce the user-experienced complexity of api endpoints.

Such complexity includes:
* library reliance - not-immediately-visible code, libraries prone to lag behind application updates
* 3d data - At times api endpoints require nested hashes, this isn't modeled wel
l for ease-of-use.
* odd url paths
* version deprecation - having to update multiple, independent references
* etc.

The complexity can be compounded in an enterprise environment as often http requests are crafted within the application rather than shared across applications.
 It is also compounded for those new-to-code.

As a proof of concept, I thought it might be fun to create a way to store favorite API endpoints in a searchable and easily executable manner. The project will handle the issue of converting 2d data structures into 3d data to enhance the user experience.  The project could incorporate an infrastructure for long running requests, coupled with a 'temporary' storage system to retrieve data once processed. If used as the soul source of api communication, it will be easy to maintain application integrity of subsidiary applicaitons during api upgrades. Project goal is primarily to act as a pass through for api requests, however there could be gui incorporation.

#### Ruby version

2.6.0

#### Testing

from circleci cli while in home directory

```
cirlceci local execute
```

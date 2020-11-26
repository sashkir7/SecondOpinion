fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
### rns_match_init
```
fastlane rns_match_init
```
Create all certificates and profiles via match
### rns_match
```
fastlane rns_match
```
Download all certificates and profiles via match
### rns_start_feature
```
fastlane rns_start_feature
```
Create feature branch from develop with the given name or checkout existing
### rns_start_hotfix
```
fastlane rns_start_hotfix
```
Create hotfix branch from develop with the given name or checkout existing
### rns_create_merge_request
```
fastlane rns_create_merge_request
```
Create new merge request on GitLab and open it using a default browser
### rns_accept_merge_request
```
fastlane rns_accept_merge_request
```
Accept merge request assigned to the current user
### rns_finish_feature
```
fastlane rns_finish_feature
```
Merge current feature branch to develop without merge request
### rns_start_release_branch
```
fastlane rns_start_release_branch
```


----

## iOS
### ios rns_firebase
```
fastlane ios rns_firebase
```
Upload build to Firebase
### ios rns_testflight
```
fastlane ios rns_testflight
```
Upload build to Testflight
### ios rns_add_devices
```
fastlane ios rns_add_devices
```
Add device UUIDs from given file
### ios rns_collect_changelog
```
fastlane ios rns_collect_changelog
```

### ios rns_env
```
fastlane ios rns_env
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).

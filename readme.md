### Main Application
[tootsuite/mastodon](https://github.com/tootsuite/mastodon) and it's dependencies

### Appendix Application
[minio/mc](https://github.com/minio/mc)
It provides the way to push assets to your cloud storages.

### How to assets:precompile my own mastodon repository
You need executing `git remote add` to clone your mastodon repository.
This image has been run `git clone`, `bundle install` and `yarn` to decrease ci running time.
You can reference [my example](https://github.com/yukimochi/mastodon/blob/yukimochi/master_with_mod/.circleci/config.yml). (CircleCI 2.0)
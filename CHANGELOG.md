# Changelog

## 0.3.0 (2026/11/20)

- [#20](https://github.com/aredotna/arena-rb/pull/20): Fixed the test suite with minitest 6 and CI on current runners - [@dblock](https://github.com/dblock).
- [#21](https://github.com/aredotna/arena-rb/pull/21): Added `Arena::V3::Client` for the Are.na v3 API and a configurable `user_agent` - [@dblock](https://github.com/dblock).
- [#22](https://github.com/aredotna/arena-rb/pull/22): Read default credentials from `ARENA_CLIENT_ID`, `ARENA_CLIENT_SECRET`, `ARENA_ACCESS_TOKEN` and `ARENA_AUTH_TOKEN` instead of `APPLICATION_ID`, `APPLICATION_SECRET` and `AUTH_TOKEN`, and no longer send `APPLICATION_SECRET` as the access token - [@dblock](https://github.com/dblock).
- [#23](https://github.com/aredotna/arena-rb/pull/23): Removed the unused `Arena::Cache` adaptors, `Arena::Error::CacheError` and the `use_caching` and `expires_in` settings - [@dblock](https://github.com/dblock).
- [#24](https://github.com/aredotna/arena-rb/pull/24): Removed the global `String#constantize` monkey patch and only instantiate `Arena::Base` classes from API class names - [@dblock](https://github.com/dblock).
- [#25](https://github.com/aredotna/arena-rb/pull/25): Added the MIT license and project links to the gemspec, and package only `lib` and documentation - [@dblock](https://github.com/dblock).
- [#26](https://github.com/aredotna/arena-rb/pull/26): Added RubyGems, test and lint badges and reorganized the README around the v3 API - [@dblock](https://github.com/dblock).

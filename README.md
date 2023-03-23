# WIP: random_thoughts_api_e2e

> **This is a Work In Progress**

This is the Acceptance Test/End-To-End (E2E) Test suite for the
[random_thoughts_api](https://github.com/brianjbayer/random_thoughts_api)
application.

Tests include...
* Testing the health check endpoints of the
  `random_thoughts_api`

* Testing an end-to-end scenario of...
  1. Creating a new random_thoughts_api user
  2. Logging in the new user
  3. Having the logged in new user create a random thought
  4. Listing the random thoughts and verifying that the new
     user's random thought is present

This test suite is intended to **supplement** the functional
tests in the `random_thoughts_api` project and provide a
basic functional "smoke test" for the application.

## Required Environment Variables
You must specify the base URL (e.g. http://localhost:3000) for
the target `random_thoughts_api` application under test using the
`E2E_BASE_URL` environment variable.

## Operating
Assuming that you have set or are supplying the `E2E_BASE_URL`
environment variable, run the following command to run the tests...
```
./script/run tests
```

This project is configured so that you can re-run just the
failing tests using the RSpec `--only-failures` (or
`--next-failure`) option.
```
./script/run tests --only-failures
```

### Code Style/Linting
This project includes the Rubocop gems
[`rubocop`](https://github.com/rubocop/rubocop),
[`rubocop-rspec`](https://github.com/rubocop/rubocop-rspec)
for linting and ensuring a consistent code style.

Run the following command to run code style/linting...
```
./script/run lint
```

### Dependency Static Security Scanning
This project includes the
[`bundler-audit`](https://github.com/rubysec/bundler-audit)
gem for statically scanning the gems for any known security
vulnerabilities.

Run the following command to run the dependency security scan...
```
./script/run secscan
```

## Specifications
### Versions
* Ruby: 3.2.1
* RSpec 3

### Support
* [RSpec](http://rspec.info/) - Test Framework
* [Faker](https://github.com/faker-ruby/faker) - Test Data
* [bundler-audit](https://github.com/rubysec/bundler-audit) - Dependency
  Static Security
* [rubocop](https://github.com/rubocop/rubocop),
  [rubocop-rspec](https://github.com/rubocop/rubocop-rspec) - Code Style
  and Linting

# random_thoughts_api_e2e

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

---

## Required Environment Variables
You must specify the base URL (e.g. http://localhost:3000) for
the target `random_thoughts_api` application under test using the
`E2E_BASE_URL` environment variable.

## Running

> **Prerequisites**: You must have Docker installed and
> running on your local machine

The easiest way to run the tests is with the docker compose
framework using the `dockercomposerun` script.

This will pull the latest docker image of this project and run
the tests against the target application specified with the
`E2E_BASE_URL` environment variable.

Assuming that you have set or supplied the `E2E_BASE_URL`
environment variable to specify the target, to run the tests
using the docker compose framework, run the following command...
```
./script/dockercomposerun
```

For example, to run the tests against a target running on your
local (e.g. host) machine on port 3000, run the following
command...
```
E2E_BASE_URL=http://host.docker.internal:3000 ./script/dockercomposerun
```

### Using the Mock Application as the Target of the Tests
If you want to run the tests using the docker compose framework
against the Mock application
[mock_random_thoughts_api](https://github.com/brianjbayer/mock_random_thoughts_api)
as the target, use the `-m` (mock) option with the
`dockercomposerun` script.  This will pull the pinned tagged
image of the mock application and run the tests against it.

To run the tests using the docker compose framework against the
mock application container, run the following command...
```
./script/dockercomposerun -m
```

> :point_right: When using the `-m` option, the value of the
> `E2E_BASE_URL` environment variable will be overridden
> in the docker compose framework

---

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
[`rubocop`](https://github.com/rubocop/rubocop) and
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

---
## Development
This project can be developed using the supplied container-based
development environment which includes `vim` and `git`.

The development environment container volume mounts your local source
code to recognize and persist any changes.

By default the development environment container executes the alpine
`/bin/ash` shell providing a command line interface.

### To Develop Using the Container-Based Development Environment
The easiest way to run the containerized development environment is with
the docker compose framework using the `dockercomposerun` script with the
`-d` (development environment) option...
```
./script/dockercomposerun -d
```

This will pull and run the latest development environment image of this
project.

> :bulb: You can use the Mock application in the docker compose
> framework development environment by specifying the `-m`
> option (e.g. `./script/dockercomposerun -dm`)

#### Building Your Own Development Environment Image
You can also build and run your own development environment image.

1. Build your development environment image specifying the `devenv` build
   stage as the target and supplying a name (tag) for the image.
   ```
   docker build --no-cache --target devenv -t rta-e2e-dev .
   ```

2. Run your development environment image in the docker-compose
   environment and specify your development environment image
   with `E2ETESTS_IMAGE`
   ```
   E2ETESTS_IMAGE=rta-e2e-dev ./script/dockercomposerun -d
   ```

#### Specifying the Source Code Location
To use another directory as the source code for the development
environment, set the `E2ETESTS_SRC` environment variable.
For example...
```
E2ETESTS_SRC=${PWD} E2ETESTS_IMAGE=rta-e2e-dev ./script/dockercomposerun -d
```

---

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

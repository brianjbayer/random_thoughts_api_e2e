# random_thoughts_api_e2e

This is the Acceptance Test/End-To-End (E2E) Test suite and E2E
environment for the
[random_thoughts_api](https://github.com/brianjbayer/random_thoughts_api)
application.

Tests include...
* Testing the health check endpoints of the
  `random_thoughts_api`

* Testing an end-to-end scenario of...
  1. Creating a new random_thoughts_api user
  2. Logging in the new user
  3. Having the logged-in new user create a random thought
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
> running on your local machine.

There are multiple uses for this project. You can...
* Run just the E2E environment
* Run the E2E tests against the (latest) E2E environment
* Run the E2E tests against a specific endpoint target (e.g. local)
* Run this as an E2E development environment for the
  `random_thoughts_api` application and other apps (`mock`) in
  the E2E environment

Regardless of how you are using this project, the easiest way
to run the E2E tests and environment is generally with the
Docker Compose framework.

### Running Just the E2E Environment
To just run the `random_thoughts_api` application E2E environment
in detached mode, simply use the `docker compose up` command:
```
docker compose up -d
```

To stop the E2E environment, use the `docker compose down`
command:

```
docker compose down
```

### Running the E2E Tests Against an Endpoint
To run the latest E2E tests against a specific endpoint
for the `random_thoughts_api` application, specify
it with the `E2E_BASE_URL` environment variable and
run the E2E tests with the `-o` (only) option
using the `dockercomposerun` script.

For example, to run the E2E tests against a target running
on your local (e.g. host) machine on port 3000, run the
following command...

```
E2E_BASE_URL=http://host.docker.internal:3000 ./script/dockercomposerun
```

### Running the E2E Tests Against the E2E Environment
To run the latest E2E tests against the latest version of the
`random_thoughts_api` application, use the
`dockercomposerun` script:

```
./script/dockercomposerun
```

#### Running a Specific App Image
To run against a specific `random_thoughts_api` image, specify
it with the `RANDOM_THOUGHTS_API_IMAGE` environment variable,
for example:

```
RANDOM_THOUGHTS_API_IMAGE=rta ./script/dockercomposerun
```

#### Running an App Dev Image
> :magic_wand: This assumes that your `random_thoughts_api`
> source code is under the same parent directory
> as this project. If not, specify its location
> with the `RANDOM_THOUGHTS_API_SRC` environment
> variable.

To run against the `random_thoughts_api` Development Image
and your local source code volume mounted into the container,
use the `dockercomposerun` script with the `-l` (local dev) option
specifying the app name `random_thoughts_api`:
```
./script/dockercomposerun -l random_thoughts_api
```

You can specify a specific dev image using the
`RANDOM_THOUGHTS_API_LOCAL_IMAGE` environment variable:
```
RANDOM_THOUGHTS_API_LOCAL_IMAGE=rta-dev ./script/dockercomposerun -l random_thoughts_api
```

### Running As an E2E Development Environment
> :magic_wand: This assumes that your `random_thoughts_api`
> source code is under the same parent directory
> as this project. If not, specify its location
> with the `RANDOM_THOUGHTS_API_SRC` environment
> variable.

You can also use this project as an E2E development
environment for the `random_thoughts_api`
application using its Development Image and local
source code volume mounted into the `random_thoughts_api`
container in the E2E environment.

1. Start either just the E2E environment or the
   E2E environment with tests,
   for example:
   ```
   ./script/dockercomposerun -d
   ```

2. Use the `dockercomposelocaldev` script specifying `random_thoughts_api`:
   ```
   ./script/dockercomposelocaldev random_thoughts_api
   ```

3. To exit, enter `exit` and this will exit the shell and restore the original
   configuration image.

---

## Operating
Assuming that you have set or are supplying the `E2E_BASE_URL`
environment variable, run the following command to run the tests...
```
./script/run tests
```

This project is configured so you can re-run only the
failing tests using the RSpec `--only-failures` (or
`--next-failure`) option:
```
./script/run tests --only-failures
```

### Code Style/Linting
This project includes the RuboCop gems
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

By default, the development environment container executes the `bash`
shell, providing a command line interface.

### To Develop Using the Container-Based Development Environment
The easiest way to run the containerized development environment is with
the Docker Compose framework using the `dockercomposerun` script with the
`-d` (development environment) option:
```
./script/dockercomposerun -d
```

This will pull and run the latest E2E environment with the development
image of this project.

#### Building Your Own Development Environment Image
You can also build and run your own development environment image.

1. Build your development environment image specifying the `devenv` build
   stage as the target and supplying a name (tag) for the image:
   ```
   docker build --no-cache --target devenv -t rta-e2e-dev .
   ```

2. Run your development environment image in the Docker Compose
   environment and specify your development environment image
   with `E2ETESTS_IMAGE`:
   ```
   E2ETESTS_IMAGE=rta-e2e-dev ./script/dockercomposerun -d
   ```

#### Specifying the Source Code Location
To use another directory as the source code for the development
environment, set the `E2ETESTS_SRC` environment variable.
For example:
```
E2ETESTS_SRC=${PWD} E2ETESTS_IMAGE=rta-e2e-dev ./script/dockercomposerun -d
```

---

## Specifications
### Versions
* Ruby: 3.4.4
* RSpec: 3

### Support
* [RSpec](http://rspec.info/) - Test Framework
* [Faker](https://github.com/faker-ruby/faker) - Test Data
* [bundler-audit](https://github.com/rubysec/bundler-audit) - Dependency
  Static Security
* [rubocop](https://github.com/rubocop/rubocop),
  [rubocop-rspec](https://github.com/rubocop/rubocop-rspec) - Code Style
  and Linting

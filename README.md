# wm

A program to help memorise words when learning a new language.

## Dependencies

* [Ruby](https://www.ruby-lang.org/en/).  Written with version [3.1.2](https://www.ruby-lang.org/en/news/2022/04/12/ruby-3-1-2-released/) - *[docs](https://docs.ruby-lang.org/en/3.1/)*.

## Usage

* Install deps: `gem install bundler && bundle install`.
* Run `bundle exec rake` to run tests and linters.
* Add your google cloud API key to `config/keys.yaml`
* Add your desired target and base languages in `config/languages.yaml`
* Add the `/exe/` directory to `$PATH` by adding to your shell configuration
  file: `export PATH=$PATH:/path/to/project/exe`, to enable running this program
  with commands such as: `wm review`


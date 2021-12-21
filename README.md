# Sentry-Gruf &middot; <a target="_blank" href="https://github.com/Cado-Labs"><img src="https://github.com/Cado-Labs/cado-labs-logos/raw/main/cado_labs_badge.svg" alt="Supported by Cado Labs" style="max-width: 100%; height: 20px"></a>

Gruf both client and server interceptors, which report bugs to the Sentry.

## Installation

```ruby
gem "sentry-gruf"
```

```shell
bundle install
# --- or ---
gem install sentry-gruf
```

```ruby
require "sentry-gruf"
```

## Usage

After you install the gem, you need to set up the Sentry. You can read about Sentry
configuration [here](https://docs.sentry.io/platforms/ruby/).

Gem provides two interceptors for both client and server sides. All you need to add this interceptor
at the beginning of interceptors stack.

For the server side, the installation will look something like this:

```ruby
Gruf.configure do |config|
  config.interceptors.clear # Like config.use_default_interceptors = false
  config.interceptors.use(Sentry::Gruf::ServerInterceptor)
  # Other interceptors go below.
end
```

### Contributing

 - Fork it ( https://github.com/Cado-Labs/sentry-gruf )
 - Create your feature branch (`git checkout -b feature/my-new-feature`)
 - Commit your changes (`git commit -am '[feature_context] Add some feature'`)
 - Push to the branch (`git push origin feature/my-new-feature`)
 - Create new Pull Request

## License

Released under MIT License.

## Supporting

<a href="https://github.com/Cado-Labs">
  <img src="https://github.com/Cado-Labs/cado-labs-resources/blob/main/cado_labs_supporting_rounded.svg" alt="Supported by Cado Labs" />
</a>

## Authors

Created by [Ivan Chernov](https://github.com/AnotherRegularDude).

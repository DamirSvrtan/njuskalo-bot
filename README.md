## Traveling Ruby

Download the Ruby binaries for platforms:

```shell
curl -L -O --fail https://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-20141215-2.1.5-linux-x86_64.tar.gz

curl -L -O --fail https://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-20141215-2.1.5-osx.tar.gz
```
Create a folder for each distribution:

```shell
mkdir ruby-linux-x86_64
mkdir ruby-os-x
```

Extract them to each folder:

```shell
tar -xzf traveling-ruby-20141215-2.1.5-linux-x86_64.tar.gz -C ruby-linux-x86_64
tar -xzf traveling-ruby-20141215-2.1.5-osx.tar.gz -C ruby-os-x
```

Delete the zipped folders:

```shell
rm traveling-ruby/traveling-ruby-20141215-2.1.5-linux-x86_64.tar.gz
rm traveling-ruby/traveling-ruby-20141215-2.1.5-osx.tar.gz
```

Run the script:

```shell
ruby-os-x/bin/ruby main.rb
```

Show the folder structure.

Add a lambda function wrapper in js.
Add a lambda-function file that calls ruby linux x86 64.

Enable to run: `chmod a+x lambda-function`

### Zip the package to upload to AWS Lambda:

```shell
cd traveling-ruby
zip -r njuskalo-bot.zip lambda-function lambda-function-wrapper.js main.rb ruby-linux-x86_64/
```

Upload zip on AWS console and add ENV variables: MAILGUN_API_KEY.

## mruby

Download the source for mruby from Github.

[5 ways to execute mruby](https://blog.mruby.sh/201207020720.html)

Unpackage it:

```shell
tar -xzf mruby-1.2.0.zip -C mruby
```

```shell
cp main.rb mruby/main.rb
```

Add the environment variables mrubygem:

```ruby
  # build_config.rb
  conf.gem :github => 'iij/mruby-env'
```

And compile:

```shell
ruby ./minirake
```

IRB console:

```bash
bin/mirb
```

Run it:

```bash
bin/mruby main.rb
```

Run it compiled:

```bash
bin/mrbc main.rb
bin/mruby -b main.mrb
```

## Mruby-CLI

Go to [Mruby Releases](https://github.com/hone/mruby-cli/releases) and download the OS X package.

Unpackage it into the root folder: `tar -xzf mruby-cli-0.0.4-x86_64-apple-darwin14.tgz`

Generate a new Mruby CLI app:

```shell
./mruby-cli -s mruby-cli-app
```

## JRuby

http://blog.headius.com/2010/03/jruby-startup-time-tips.html

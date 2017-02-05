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

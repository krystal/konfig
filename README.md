# Konfig

This toolkit allows you to easily access configuration variables from a variety of different sources based on a pre-defined schema.

There are a few built-in config sources that you can use, but you can also easily create your own. The sources available out the box are:

- Environment variables
- YAML files
- Directory of plain text files

## Installation

Just add the gem to your Gemfile as normal.

```ruby
gem 'konfig-config', '~> 1.0'
```

## Getting started

It's fairly easy to get started with Konfig. The block below shows the key things you need to know.

```ruby
# Begin by defining a schema which you wish to use for your application.
# This should be configured globally.
schema = Konfig::Schema.draw do

  group :app do
    string :hostname do
      description "The hostname for the application"
    end

    integer  :port do
      description "The port for the application"
      default 8080
    end

    string :extra_hostnames do
      array
      description "Additional hosts to be permitted to receive requests"
      transform { |v| v.downcase }
    end
  end

  # You can also define things more succicntly if you wish.
  group :mysql do
    string    :hostname,        default: 'localhost'
    integer   :port,            default: 3306
    string    :username,        default: 'root'
    string    :password
    string    :database_name,   default: 'my_database'
    string    :roles,           array: true
  end

end

# Create a source object. In this example, we're using the environment
# variables source and providing `ENV` which contains all the environment
# variables provided to the process.
source = Konfig::Sources::Environment.new(ENV)

# Create your final configuration object by providing an array of sources.
config = Konfig::Config.build(schema, sources: [source])
config.app.hostname = "localhost"
config.app.port = 8080
config.app.extra_hostnames = ["example.com", "example.org"]
```

## Notes

- All configuration is evaluated when the config is built.
- There is no nesting of configuration other than adding all attributes into a group at present.
- When config is built, values will be used from the sources in the order they are provided. If a value is not found in a source, the next source will be used otherwise the value will come from the default configured in the schema.

## Types

You can use the following types in your schema:

- `string`
- `integer`
- `float`
- `boolean`

## Value transformation

You can transform the value of an attribute by providing a block to the `transform` method. The block will be passed the value of the attribute and should return the transformed value.

```ruby
group :app do
  string :trusted_ipds do
    array
    transform { |ip| IPAddr.new(ip) }
  end
end
```

## Source options

### Environment variables

If you have your configuration in environment variables, you can load that in as shown. Environment variables are the most common source of configuration. The config value will be taken by uppercasing the group and attribute name and joining them with an underscore. For example, the config value for `web.hostname` will be taken from the environment variable `WEB_HOSTNAME`.

```ruby
source = Konfig::Sources::Environment.new(ENV)

# If your attribute is an array, by default, it will be split based on commas.
# You can override this if you wish.
source = Konfig::Sources::Environment.new(ENV, array_seperator: /\s+/)
```

### YAML

If you have your configuration in a YAML file, you can load that in as shown.

```ruby
source = Konfig::Sources::YAML.new(File.read('config.yml'))
```

### Directory

If you have a directory of plain text files, you can load that in as shown. This is likely if you are mounting a config map on a Kubernetes cluster, for example. The path to the config file will be determined by joining the group name and the attribute name with a `.`. For example, the config value for `web.hostname` will be taken from the file `/config/web.hostname` (where `/config` is the path you provide to the directory).

```ruby
source = Konfig::Sources::Directory.new('/config')

# By default, the contents of the file read will be stripped. You can disable
# this if you wish.
source = Konfig::Sources::Directory.new('/config', strip_contents: false)

# If your attribute is an array, by default, it will be split based on
# new line characters. You can override this if you wish.
source = Konfig::Sources::Directory.new('/config', array_seperator: /\,/)
```

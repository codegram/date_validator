# date_validator [![Build Status](https://travis-ci.org/codegram/date_validator.png?branch=master)](https://travis-ci.org/codegram/date_validator)


A simple date validator for Rails 3. Should be compatible with all latest Rubies.


```shell
$ gem install date_validator
```

And I mean simple. In your model:

```ruby
validates :expiration_date,
          :date => {:after => Proc.new { Time.now },
                    :before => Proc.new { Time.now + 1.year } }
# Using Proc.new prevents production cache issues
```

If you want to check the date against another attribute, you can pass it
a Symbol instead of a block:

```ruby
# Ensure the expiration date is after the packaging date
validates :expiration_date,
          :date => {:after => :packaging_date}
```

For now the available options you can use are `:after`, `:before`,
`:after_or_equal_to` and `:before_or_equal_to`.

If you want to specify a custom message, you can do so in the options hash:

```ruby
validates :start_date,
  :date => {:after => Proc.new { Date.today }, :message => 'must be after today'},
  :on => :create
```

Pretty much self-explanatory! :) 

If you want to make sure an attribute is before/after another attribute, use:

```ruby
validates :start_date, :date => {:before => :end_date }
```

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send us a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2013 Codegram. See LICENSE for details.

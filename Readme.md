# date_validator

A simple date validator for Rails 3. Compatible with Ruby 1.8, 1.9, JRuby 1.5.3
and Rubinius 1.1.

    $ gem sources -a http://gemcutter.org/
    $ gem install date_validator

And I mean simple. In your model:

    validates :expiration_date,
              :date => {:after => Proc.new { Time.now },
                        :before => Proc.new { Time.now + 1.year } }
    # Using Proc.new prevents production cache issues

For now the available options you can use are `:after`, `:before`,
`:after_or_equal_to` and `:before_or_equal_to`.

Pretty much self-explanatory! :) 

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send us a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2011 Codegram. See LICENSE for details.

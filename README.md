# Nifty

A alternative light weight Rails ActiveRecord query result builder using Ruby Hash object.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nifty'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nifty

## Usage

* `#nifty`

`#nifty` is a activerecord relation method, it can be chained to any activerecord relation object. However, `#nifty` returns an
array which contains pure Ruby hash, so do not use other chainable relation methods after `#nifty` method.

```ruby
User.all.nifty.each do |user|
  puts user['id']
  puts user['phone_no']
end
```

* `#nifty_find`

`#nifty_find` is an alternative to activerecord's `find` method

```ruby
# app/models/user.rb
class User < ActiveRecord::Base 
  extend Nifty::ClassMethods
end

# rails console
User.nifty_find(1) # it returns Hash

# => {"id"=>1, "username": "gaotongfei"}
```


* `#nifty_batches`

Similar to activerecord's `find_in_batches`, see example

```ruby
User.all.nifty_batches do |users|
  users.each do |user|
    user['id']
    user['phone_no']
  end
end
```


## Benchmark

```ruby
require 'benchmark'
require 'benchmark-memory'

def ar_all
  User.all.each do |user|
    user.id
    user.phone_no
  end
end

def nifty_all
  User.all.nifty.each do |user|
    user['id']
    user['phone_no']
  end
end

def ar_find
  User.all.each do |user|
    User.find(user.id)
  end
end

def _nifty_find
  User.all.nifty.each do |user|
    User.nifty_find(user['id'])
  end
end

def ar_batch
  User.find_in_batches do |users|
    users.each do |user|
      user.id
      user.phone_no
    end
  end
end

def nifty_batch
  User.all.nifty_batches do |users|
    users.each do |user|
      user['id']
      user['phone_no']
    end
  end
end

namespace :benchmark do
  task all: :environment do
    Benchmark.bm do |x|
      x.report('ar all') do
        ar_all
      end
      x.report('nifty all') do
        nifty_all
      end
    end

    Benchmark.memory do |x|
      x.report('ar all') do
        ar_all
      end
      x.report('nifty all') do
        nifty_all
      end
    end
  end

  task find: :environment do
    Benchmark.bm do |x|
      x.report('ar find') { ar_find }
      x.report('nifty find') { _nifty_find }
    end

    Benchmark.memory do |x|
      x.report('ar find') { ar_find }
      x.report('nifty find') { _nifty_find }
    end
  end

  task batch: :environment do
    Benchmark.bm do |x|
      x.report('ar batch') { ar_batch }
      x.report('nifty batch') { nifty_batch }
    end

    Benchmark.memory do |x|
      x.report('ar batch') { ar_batch }
      x.report('nifty batch') { nifty_batch }
    end
  end
end
```

result:
```
       user     system      total        real
ar all  0.080000   0.010000   0.090000 (  0.099422)
nifty all  0.010000   0.000000   0.010000 (  0.011916)

Calculating -------------------------------------
              ar all   903.210k memsize (   928.000  retained)
                         8.076k objects (     1.000  retained)
                        50.000  strings (     0.000  retained)
          nifty all   453.736k memsize (   928.000  retained) 
                         3.054k objects (     1.000  retained)
                        50.000  strings (     0.000  retained)


       user     system      total        real
ar find  0.210000   0.030000   0.240000 (  0.328035)
nifty find  0.110000   0.020000   0.130000 (  0.177724)

Calculating -------------------------------------
             ar find     5.144M memsize (   928.000  retained)
                        53.719k objects (     1.000  retained)
                        50.000  strings (     0.000  retained)
          nifty find     3.525M memsize (   928.000  retained)
                        30.568k objects (     1.000  retained)
                        50.000  strings (     0.000  retained)


       user     system      total        real
ar batch  0.060000   0.010000   0.070000 (  0.086629)
nifty batch  0.000000   0.010000   0.010000 (  0.007248)

Calculating -------------------------------------
            ar batch   907.536k memsize (   928.000  retained)
                         8.158k objects (     1.000  retained)
                        50.000  strings (     0.000  retained)
         nifty batch   457.822k memsize (   928.000  retained)
                         3.136k objects (     1.000  retained)
                        50.000  strings (     0.000  retained)
```

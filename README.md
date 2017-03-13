= Introduction

CompactFlags comes to serve models with several boolean flags. in large data volumes where the flags can be used to slice the data in several ways. queries tend to be heavier and more indexes are needed by time.

This Gem is made so it can store several flags in one integer attribute through bit wise operations. the attribute represents the state of each record. And is much more performant in database queries

## Compatible

  Compatible with Rails 4 and 5

## Installation

  ```ruby
  gem 'compact_flags'

  ```

## Database Migrations

You need to add an integer column only to your model. which will be used later as the flags store, you can just use a migration that adds inter column like below:

  class AddRoles < ActiveRecord::Migration
    def change
      add_column :users, :roles, :integer, :null=>false, :default=>0
    end
  end


## Usage example

After adding the gem and creating an integer column, for example: "roles" to your model, add the "compact_flags" lines passing the flags store column name, and the array of flags

  class User < ActiveRecord::Base
    compact_flags :roles  => [:admin, :moderator, :editor]
  end

  ```ruby
  # the corresponding getters and setters for all the boolean flags has been created
  user = User.new
  user.admin = true
  user.admin?            # <=  will return true
  user.moderator?        # <=  will return false
  user.save
  ```

Scopes will also be automatically available for objects retrieval from the database.
Two names scopes will be available for each flag. with the plural name of the flag, and another one
preceded with "not_".
scopes gives a suitable flexibility because they can be used in a cascaded style to build complex conditions

  ```ruby
  User.admins                               # <=  The pluralize of flag name
  User.not_moderators                       # <=  The pluralize of flag name with 'not_'
  User.not_moderators.admins
  ```

Other methods are also available to return the relevant condition part as a string, for concatenation with a condition string. those comes with the in the form of _where_ and _where_not_

  ```ruby
  User.admin_value              # => returns associated value to admin => 1
  User.moderator_value          # => returns associated value to moderator => 2
  User.where_admin              # => "(roles & 1) > 0"
  User.where_not_admin          # => "(roles & 1) = 0"
  User.where_not_moderator      # => "(roles & 2) = 0"
  ```

## Contributions

* Mahmoud Said aka modsaid (mahmoud@modsaid.com)
* Mostafa Ragab aka dr-click (ragab.mostafa@gmail.com)

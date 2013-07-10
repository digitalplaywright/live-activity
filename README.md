# LiveActivity

LiveActivity is a simple Ruby activity stream gem for use with the ActiveRecord ODM framework inspired by
Streama by Christopher Pappas.

[![travis](https://secure.travis-ci.org/digitalplaywright/live_activity.png)](http://travis-ci.org/digitalplaywright/live_activity)

## Install

    gem install live_activity

## Usage

### Create migration for activities and migrate the database (in your Rails project):

```ruby
rails g public_activity:migration
rake db:migrate
```

A join table must also be created for all receivers. E.g if users are receivers:

``` ruby
create_table :activities_users, :id => false do |t|
  t.references :activity, :user
end

add_index :activities_users, [:activity_id, :user_id ]
```

### Define Activities

Create an Activity model and define the activities and the fields you would like to cache within the activity.

An activity consists of an actor, a verb, an act_object, and a target.

``` ruby
class Activity < ActiveRecord::Base
  include LiveActivity::Activity

  has_and_belongs_to_many :users

  activity :new_enquiry do
    actor        :User
    act_object   :Article
    act_target   :Volume
  end
end
```

The activity verb is implied from the activity name, in the above example the verb is :new_enquiry

The act_object may be the entity performing the activity, or the entity on which the activity was performed.
e.g John(actor) shared a video(act_object)

The target is the act_object that the verb is enacted on.
e.g. Geraldine(actor) posted a photo(act_object) to her album(target)

This is based on the Activity Streams 1.0 specification (http://activitystrea.ms)

### Setup Actors

Include the Actor module in a class and override the default followers method.

``` ruby
class User < ActiveRecord::Base
  include LiveActivity::Actor

  has_and_belongs_to_many :activities

end
```



### Publishing Activity

In your controller or background worker:

``` ruby
current_user.publish_activity(:new_enquiry, :act_object => @enquiry, :target => @listing)
```
  
This will publish the activity to the mongoid act_objects returned by the #followers method in the Actor.

To send your activity to different receievers, pass in an additional :receivers parameter.

``` ruby
current_user.publish_activity(:new_enquiry, :act_object => @enquiry, :target => @listing, :receivers => :friends) # calls friends method
```

``` ruby
current_user.publish_activity(:new_enquiry, :act_object => @enquiry, :target => @listing, :receivers => current_user.find(:all, :conditions => {:group_id => mygroup}))
```

## Retrieving Activity

To retrieve all activity for an actor

``` ruby
current_user.activity_stream
```
  
To retrieve and filter to a particular activity type

``` ruby
current_user.activity_stream(:verb => 'new_enquiry')
```

#### Options

Additional options can be required:

``` ruby
class Activity < ActiveRecord::Base
  include LiveActivity::Activity

  has_and_belongs_to_many :users

  activity :new_enquiry do
    actor        :User
    act_object   :Article
    act_target   :Volume
    option       :country
    option       :city
  end
end
```

The option fields are stored using the ActiveRecord 'store' feature.


#### Bond type

A verb can have one bond type. This bond type can be used to classify and quickly retrieve
activity feed items that belong to a particular aggregate feed, like e.g the global feed.

``` ruby
class Activity < ActiveRecord::Base
  include LiveActivity::Activity

  has_and_belongs_to_many :users

  activity :new_enquiry do
    actor        :User
    act_object   :Article
    act_target   :Volume
    bond_type    :global
  end
end
```
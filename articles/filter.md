---
layout: default
title:  Filters
date:   2013-08-27 17:39:22
categories: filter
---

## Basic

By default query report supports 3 type of filters
1. text (using ransack equality filter)
2. boolean (provides a drop down of ''/yes/no choices)
3. date (a date between filter with ransack gteq and lteq)

```ruby
reporter(User.scoped) do
    filter :name, type: :text
    filter :created_at, type: :date
    filter :married, type: :boolean
    column :name
	column :age
end
```

By default query report generates the date input with the HTML 5 date type.
But you can change any of the filter to look the way you want.

## Custom filter with supported types

If you want to customize the filter and write your own query to do so, then you can do it as follows,

```ruby
reporter(User.scoped) do
    #supporting text filter
    filter :name, type: :text do |query, name|
        query.where("name like ?", "%#{name}%")
    end
    #supporting date filter
    filter :created_at, type: :date do |query, from, to|
        query.where("created_at >= ? and created_at =< ?",
                     from.to_date.beginning_of_day, to.to_date.end_of_day)
    end
    #supporting boolean filter
    filter :married, type: :boolean do |query, married|
        query.where(married: married)
    end

    column :name
	column :age
end
```

## Custom filter with custom defined type

If you want to add a custom filter that you want to reuse for other reports, such as user auto complete,

```ruby
reporter(User.scoped) do
    #supporting text filter
    filter :name, type: :user do |query, name|
        query.where("name like ?", "%#{name}%")
    end
    column :name
	column :age
end
```
As you can see we have defined the filter type as 'user', which we are going to support in the next section.

Now copy the query_report_filter_helper.rb from the gem in to your helper folder. And define your user auto complete as follows,

```ruby
def query_report_user_filter(name, value, options={})
    user_name = User.find(value).name rescue ''

    hidden_field_id = name.delete(']').gsub(/\[/, '_')
    concat user_search_field_tag "#{name}[search_field]", user_name, options.merge(:'sync-id' => hidden_field_id)
    hidden_field_tag name, value
end
```

If you define a custom type which is not supported by query report by default then query report will expect that you
have defined a helper function as follows,

 ```ruby
 def query_report_{{filter_type}}_filter(name, value, options={})
    ...
 end
 ```
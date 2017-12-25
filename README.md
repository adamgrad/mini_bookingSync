# mini BookingSync API

## Setup
These instruction will get you a copy of the project up and running on your local machine.

```
$ cd ~/workspace
$ git clone https://github.com/adamgrad/mini_bookingSync.git
$ cd mini_bookingSync
$ bundle install
```
### Important config
Make sure to rename config files
```
$ mv config/application.yml.example config/application.yml
$ mv config/database.yml.example config/database.yml
```

Create database
```
$ rails db:migrate
```

After all those steps your test suite should pass

```
$ bin/rspec
```


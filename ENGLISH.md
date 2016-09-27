# kontes-terbuka: Indonesian Online Math Contest website
![Indonesian Online Math Contest Logo](https://github.com/donjar/kontes-terbuka/raw/production/app/assets/images/logo-hires.png)
[Klik di sini untuk versi Bahasa Indonesia.](README.md)

This repository contains code for Indonesian Online Math Contest's website
which can be accessed in https://ktom.tomi.or.id. This website is made by
two members of our organization:
- Herbert Ilhan Tanujaya (@donjar)
- Jonathan Mulyawan Woenardi (@woenardi)

This website was originally made to learn web development in Ruby on Rails.
However, the source code keeps on expanding as we add on more features.

## Setup with Vagrant
Note: the Vagrant setting provided uses 2 GB of RAM. If you feel that it's
a lot, edit Vagrantfile; change `vb.memory` from `"2048"` to `"1024"` or
however you want.

Install Vagrant and VirtualBox:
- https://www.vagrantup.com/downloads.html
- https://www.virtualbox.org/wiki/Downloads

Vagrant is a virtual machine that is used to run this application. It is used
to ensure stability across different machines. Vagrant uses VirtualBox to
run its machine.

Install Vagrant plugins: `vagrant plugin install vagrant-vbguest`

Run Vagrant: `vagrant up`

This can take up to 1 hour, since Vagrant needs to set up everything from
scratch, such as downloading Ubuntu (!), setup database, Ruby, and Rails.
Please wait. :3

While waiting, these are files you need to set up on your own:
- config/initializers/env.rb; copy from config/initializers/env.rb.default
- config/database.yml; copy from config/database.yml.default
- public/contest_files/certificates. Files you need in this directory to
create certificates): barra.png, frame.jpg, ilhan.png, logo.png
- app/views/contests/certificate.tex.haml
- config/initializers/line_targets.rb. It contains the variable `LINE_TARGETS`
assigned to a dictionary, in which the keys are nicknames and the values
are MIDs. All users here will be nagged by a LINE client. For example:
```ruby
TARGETS = {
  'Amir': 'u1284eee',
  'Bayu': 'u92a3',
  'Charlie': 'u004932'
}.freeze
```

After everything is done, enter Vagrant: `vagrant ssh`

Moment of truth: `bin/rails s` and open localhost:3000 in your browser.

It fails? `vagrant destroy` and repeat `vagrant up`.

Clean up system: (optional)
```
sudo apt-get autoremove
sudo apt upgrade
sudo apt dist-upgrade
```

## Import database
(Daily dump is done with `pg_dump kontes_terbuka_production` piped into `split`)

To import database from the provided daily dumps, copy them to `import` folder
in root. Then, run:
```bash
chmod u+x import.sh
./import.sh
```

## Install LaTeX in Vagrant
LaTeX is installed by TeX Live with the provided profile. The installation
provided is enough to run the LaTeX things this app needs without making it
too bloated. Run:
```bash
chmod u+x tex.sh
./tex.sh
```

## Contribute
Please fork :D

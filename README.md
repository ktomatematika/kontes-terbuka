# kontes-terbuka
Repo ini berisi kode untuk website. Website apa ya...

## Setup, dengan Vagrant
Catatan: Setting Vagrant ini menggunakan 2 GB RAM. Jika dirasa terlalu banyak,
edit saja di Vagrantfile: ganti `vb.memory` dari `"2048"` menjadi `"1024"` atau
berapapun.

Install Vagrant dan VirtualBox:
- https://www.vagrantup.com/downloads.html
- https://www.virtualbox.org/wiki/Downloads

Vagrant adalah sebuah virtual machine yang digunakan untuk menjalankan app.
Keuntungannya, development environmentnya akan stabil di mesin manapun.  
Vagrant menggunakan VirtualBox untuk menjalankan virtual machinenya.

Install beberapa plugin Vagrant:
```
vagrant plugin install vagrant-vbguest
```

Nyalakan Vagrant: `vagrant up`  
Ini bisa memakan waktu 1 jam, karena vagrant perlu mensetup segalanya
dari awal, termasuk download Ubuntu (!), setup database, Ruby, dan Rails.
Bersabarlah. :3

Sambil menunggu, copy file env.rb.default ke env.rb dan isi dengan environment variables yang digunakan.

Setelah itu, masuk ke Vagrant: `vagrant ssh`

Masuk ke tempat development: `cd /vagrant`

Moment of truth: `bin/rails s` dan buka localhost:3000 di browser.

Aduh, gagal? `vagrant destroy` dilanjutkan `vagrant up` lagi.

Rapikan sistem: (optional, ga penting, kadang bisa rusak malah)
```
sudo apt-get autoremove
sudo apt upgrade
sudo apt dist-upgrade
```

## Kontribusi
Ayok difork! Lihat issuesnya tuh sebanyak pasir di pantai.

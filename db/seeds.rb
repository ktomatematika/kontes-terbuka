[:admin, :student, :corrector, :banned].each do |role|
  Role.where({ name: role }, without_protection: true).first_or_create
end

["D.I. Aceh", "Sumatera Utara", "Sumatera Barat", "Riau", "Kep. Riau", 
	"Jambi", "Bengkulu", "Bangka Belitung", "Sumatera Selatan", "Lampung", 
	"Banten", "D.K.I. Jakarta", "Jawa Barat", "Jawa Tengah", "Jawa Timur", 
	"D. I. Yogyakarta", "Bali", "Nusa Tenggara Barat", "Nusa Tenggara Timur", 
	"Kalimantan Barat", "Kalimantan Tengah", "Kalimantan Utara", "Kalimantan Timur", 
	"Kalimantan Selatan", "Sulawesi Barat", "Sulawesi Selatan", "Gorontalo", 
	"Sulawesi Tengah", "Sulawesi Utara", "Sulawesi Tenggara", "Maluku Utara", 
	"Maluku", "Papua Barat", "Papua", "Lainnya"].each do |province|
		Province.find_or_create_by(name: province)
end

["Kelas 8", "Kelas 9", "Kelas 10", "Kelas 11", "Kelas 12", "Guru sekolah", 
	"Guru/dosen/pengajar olimpiade", "Umum"].each do |status|
		Status.find_or_create_by(name: status)
end

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

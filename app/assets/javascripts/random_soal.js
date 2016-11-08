var problem_array = [
	['Tentukan banyaknya pasangan bilangan bulat $(m, n)$ ' +
	'yang memenuhi persamaan \\[ 4(n^2 + m) = mn. \\]',
	'KTO Matematika Oktober 2015'],
	['Sebuah bilangan asli disebut <em>spesial</em> jika bilangan ' +
	'tersebut habis dibagi oleh tiap-tiap digit (angka) nya yang ' +
	'bukan 0. Ada berapa paling banyak bilangan-bilangan berurutan ' +
	'yang semuanya spesial?',
	'KTO Matematika Oktober 2015'],
	['Misalkan $ABCD$ adalah sebuah segiempat konveks yang ' +
	'memenuhi $AB = 10$, $CD = 3\\sqrt{6}$, $\\angle ' +
	'ABD = 60^{\\circ}$, $\\angle BDC = 45^{\\circ}$, dan ' +
	'$BD = 13 + 3 \\sqrt{3}$. Tentukan panjang $AC$.',
	'KTO Matematika Oktober 2015'],
	['Tentukan banyaknya pasangan bilangan asli $(a, b)$ ' +
	'demikian sehingga $a \\times b = 15^{15}$.',
	'KTO Matematika September 2015'],
	['Barisan $a_1, a_2, \\ldots$ didefinisikan dengan $' +
	'a_k = (k^2 + k + 1)k!$ untuk $k = 1, 2, \\ldots$. ' +
	'Misalkan \\[ \\frac{1 + a_1 + a_2 + \\cdots + a_{24}}{a_{25}} ' +
	'= \\frac{m}{n} \\] dengan $m, n$ adalah bilangan asli ' +
	'yang relatif prima. Hitunglah $m + n$.',
	'KTO Matematika September 2015'],
	['Diketahui $p, q, r$ bilangan prima yang memenuhi $p ' +
	'+ q = r$. Jika $p$ anggota $\\{ 1, 2, \\ldots, 100 ' +
	'\\}$ tentukan nilai terbesar $p$ yang mungkin.',
	'KTO Matematika Agustus 2015'],
	['Diberikan persegi $ABCD$. Misalkan $E$ dan $F$ ' +
	'berturut-turut titik tengah dari sisi $AD$ dan ' +
	'$AB$ dan misalkan pula $G$ merupakan titik potong ' +
	'antara garis $CE$ dan $DF$. Diketahui bahwa luas ' +
	'segitiga $DEG$ adalah 1. Hitung luas persegi $ABCD$.',
	'KTO Matematika Agustus 2015'],
	['Tentukan banyaknya bilangan asli $n \\in \\{ 1, 2, ' +
	'\\ldots, 1000 \\}$ yang memenuhi 7 habis membagi $n^2 + ' +
	'5$.',
	'KTO Matematika November 2015'],
	['Tentukan banyaknya pasangan terurut bilangan real $(a, b, ' +
	'c)$ yang memenuhi \\[ a^4 + b^4 + c^4 + 1 = 4abc. \\]',
	'KTO Matematika November 2015'],
	['Tentukan banyaknya bilangan kuadrat sempurna yang habis ' +
	'membagi \\[ 1! \\times 2! \\times \\ldots \\times 8! \\times ' +
	'9!. \\]',
	'KTO Matematika November 2015'],
	['Tentukan banyaknya pasangan terurut bilangan asli $(a, b, ' +
	'c)$ sehingga \\[ abc + ab + ac = 24. \\]',
	'KTO Matematika Desember 2015'],
	['Titik $E$ terletak di luar persegi $ABCD$. Jika ' +
	'jarak dari $E$ ke $AC$ adalah 6, ke $BD$ ' +
	'adalah 17, dan ke titik sudut $ABCD$ terdekat adalah 10, ' +
	'berapakah luas persegi $ABCD$?',
	'KTO Matematika Desember 2015'],
	['Tentukan nilai $x$ dengan $0 < x < 90$ yang ' +
	'memenuhi \\[ \\tan x^{\\circ} = \\frac{\\sin 12^{\\circ} + ' +
	'\\sin 24^{\\circ}}{\\cos 12^{\\circ} + \\cos 24^{\\circ}}. ' +
	'\\]',
	'KTO Matematika Januari 2016'],
	['Jika $a$, $b$, dan $c$ adalah akar-akar ' +
	'dari suku banyak $f(x) = x^3 - 3x + 1$, hitunglah nilai ' +
	'dari $(a + b + ab)(b + c + bc)(c + a + ca)$.',
	'KTO Matematika Januari 2016'],
	['Hitung nilai dari \\[ \\frac{1}{1331} \\sum_{a = 1}^{11} ' +
	'\\sum_{b = 1}^{11} \\sum_{c = 1}^{11} (abc + ab + bc + ca + a ' +
	'+ b + c). \\]',
	'KTO Matematika Februari 2016'],
	['Tentukan sisa pembagian $1^1 + 3^3 + \\cdots + ' +
	'1023^{1023}$ oleh 1024.',
	'KTO Matematika Februari 2016'],
	['Misalkan $p$ dan $q$ adalah bilangan real ' +
	'sehingga untuk setiap bilangan real $a$ dan $b$, ' +
	'\\[ 2a, 3b - a, pa + qb \\] membentuk barisan aritmetika. ' +
	'Tentukan nilai dari $p^2 + q^2$.',
	'KTO Matematika Maret 2016'],
	['Sebuah dadu standar dilempar sebanyak 4 kali. Misalkan $a$, ' +
	'$b$, $c$, dan $d$ berturut-turut adalah ' +
	'mata dadu yang muncul pada pelemparan pertama, kedua, ketiga, ' +
	'dan keempat. Jika peluang bahwa $a + b > c + d$ bisa ' +
	'dinyatakan dalam bentuk $\\frac{p}{q}$ dengan $p$ ' +
	'dan $q$ adalah bilangan asli yang relatif prima, ' +
	'tentukan nilai $p + q$.',
	'KTO Matematika Maret 2016'],
	['Misalkan $X = 3 + 33 + 333 + \\cdots + 333\\cdots 333$, ' +
	'di mana bilangan terakhir di deret tersebut mengandung ' +
	'2016 digit 3, dan $Y$ adalah jumlah digit (angka ' +
	'penyusun) dari $X$. Tentukanlah nilai $Y$.',
	'KTO Matematika April 2016'],
	['Carilah jumlah semua akar real dari persamaan \\[ x + ' +
	'\\frac{x}{\\sqrt{x^2 - 1}} = 2016. \\]',
	'KTO Matematika April 2016'],
	['Diberikan sebuah barisan aritmetika tak berhingga $a_1, a_2, a_3, ' +
	'\\ldots$. Misalkan beberapa (bisa jadi tak berhingga banyaknya) ' +
	'suku dibuang dari barisan ini sehingga diperoleh barisan geometri ' +
	'tak berhingga $1, r, r^2, \\ldots$ untuk suatu bilangan real ' +
	'positif $r$. Tentukan semua nilai yang mungkin untuk $r$.',
	'KTO Matematika Mei 2016'],
	['Adakah dua bilangan prima $p$ dan $q$ yang memenuhi \\[p^2 + q^2 ' +
	'= p^5 - q\\]?',
	'KTO Matematika Mei 2016'],
	['Dua buah lingkaran dengan jari-jari 4 dan 7 terletak pada satu ' +
	'bidang. Diketahui bahwa kedua lingkaran tersebut memiliki tepat ' +
	'tiga buah garis singgung persekutuan. Tentukan jarak kedua pusat ' +
	'lingkaran tersebut.',
	'KTO Matematika Juni 2016'],
	['Misalkan $\\angle ABC = \\angle ACB = 70^{\\circ}$. Titik $P$ ' +
	'terletak di dalam segitiga $ABC$ sedemikian sehingga $\\angle PCA ' +
	'= 40^{\\circ}$ dan $AP = BC$. Tentukan besar $\\angle PAB$.',
	'KTO Matematika Juni 2016'],
];

function get_rand() {
	return (new Date).getSeconds() % (3 * problem_array.length);
}

function show_prob(item) {
	if ($('.random-soal').length !== 0) {
		$('.random-soal').html(problem_array[item][0]);
		$('.random-soal-sumber').html('Sumber: ' + problem_array[item][1]);
		renderMathInElement($('.random-soal')[0], {
			delimiters: [
				{left: '$', right: '$', display: false},
				{left: '\\[', right: '\\]', display: true},
			],
		});
	}
}

$(document).ready(function() {
	show_prob(get_rand());
	$('.right-ganti-soal').contextmenu(function(e) {
		e.preventDefault();
		show_prob(get_rand());
	});
	$('.ganti-soal').click(function(e) {
		show_prob(get_rand());
	});
});

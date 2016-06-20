module.exports = {
	'env': {
		'browser': true,
		'jquery': true
	},
	'extends': 'eslint:recommended',
	'rules': {
		'indent': ['error', 'tab'],
		'linebreak-style': ['error', 'unix'],
		'quotes': ['error', 'single'],
		'semi': ['error', 'always'],
		'valid-jsdoc': 'warn',
		'no-extra-parens': ['error', 'all'],
		'no-prototype-builtins': 'error',
		'no-unsafe-finally': 'error',
		'no-undefined': 'error',
		'no-undef-init': 'error',
		'no-use-before-define': 'error',
		'no-shadow': 'error',
		'no-label-var': 'warn',
		'array-callback-return': 'warn',
		'block-scoped-var': 'warn',
		'curly': ['error', 'all'],
		'consistent-return': 'error',
		'dot-location': ['error', 'property'],
		'dot-notation': 'warn',
		'eqeqeq': 'warn',
		'no-caller': 'error',
		'no-alert': 'warn',

	},
	'globals': {
		'now': false,
		'months': false,
		'short_days': false,
		'long_days': false,
		'choose_color': false,
		'load_colors': false,
		'renderMathInElement': false,
		'data_panitia': false
	}
};

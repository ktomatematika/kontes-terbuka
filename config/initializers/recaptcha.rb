if Rails.env == 'development' || Rails.env == 'test'
	Recaptcha.configure do |config|
		config.public_key = '6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI'
		config.private_key = '6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe'
	end
end

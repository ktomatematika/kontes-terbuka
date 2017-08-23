# frozen_string_literal: true

# rubocop:disable Style/AutoResourceCleanup
PDF = File.open(Rails.root.join('test', 'support', 'a.pdf'), 'r')
TEX = File.open(Rails.root.join('test', 'support', 'a.tex'), 'r')

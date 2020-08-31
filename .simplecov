# frozen_string_literal: true

require 'simplecov'
require 'simplecov-cobertura'

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::CoberturaFormatter
]

SimpleCov.start('rails') do
  track_files false

  SimpleCov.start('rails') do
    track_files false

    add_group 'Mailers',    'app/mailers'
    add_group 'Validators', 'app/validators'
    add_group 'Workers',    'app/workers'
  end
end

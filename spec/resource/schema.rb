# frozen_string_literal: true

Konfig::Schema.draw do
  group :rails do
    string :env, default: 'development' do
      description 'The environment to run the app in'
    end
    boolean :log_to_stdout, default: true do
      description 'Whether to log to STDOUT'
    end
  end

  group :mysql do
    string :host, default: 'localhost' do
      desc 'The MySQL host'
    end
    integer :port, default: 3306
    string :username, default: 'root'
    string :password
    string :database, default: 'super_app'
    string :roles, array: true, default: %w[read write]
  end
end

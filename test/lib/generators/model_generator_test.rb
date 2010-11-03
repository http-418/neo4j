require 'test_helper'
require 'generators/neo4j/model/model_generator.rb'

class Neo4j::Generators::ModelGeneratorTest < Rails::Generators::TestCase
  destination File.join(Rails.root)
  tests Neo4j::Generators::ModelGenerator

  setup :prepare_destination
  setup :copy_routes

  test "invoke with model name" do
    content = run_generator %w(Account)

    assert_file "app/models/account.rb" do |account|
      assert_class "Account", account do |klass|
        assert_match /Neo4j::Rails::Model/, klass        
      end
    end
  end

  test "invoke with model name and attributes" do
    content = run_generator %w(Account name:string age:integer)

    assert_file "app/models/account.rb" do |account|
      assert_class "Account", account do |klass|
        assert_match /property :name/, klass
        assert_match /property :age/, klass        
      end
    end
  end  
     
  test "invoke with model name and --timestamps option" do
    content = run_generator %w(Account --timestamps)

    assert_file "app/models/account.rb" do |account|
      assert_class "Account", account do |klass|
        assert_match /property :created_at/, klass
        assert_match /property :updated_at/, klass        
      end
    end
  end  

  test "invoke with model name and --parent option" do
    content = run_generator %w(Admin --parent User)
    assert_file "app/models/admin.rb" do |account|
      assert_class "Admin", account do |klass|
        assert_match /<\s+User/, klass
      end
    end
  end
end
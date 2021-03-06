require "test/helper"
require "test/app_helper"
require 'open4'
require 'rest_client'

module Osheet
  class RailsTwoTest < Test::Unit::TestCase
    include RailsTestHelpers

    before_once do
      test_rails_app :two, :start, 'localhost', 3002
    end
    after_once do
      test_rails_app :two, :stop, 'localhost', 3002
    end

    should "respond with osheet data" do
      assert_osheet_data 'rails two', RestClient.get("http://localhost:3002/things.xls")
    end

  end

  class RailsThreeTest < Test::Unit::TestCase
    include RailsTestHelpers

    before_once do
      test_rails_app :three, :start, 'localhost', 3003
    end
    after_once do
      test_rails_app :three, :stop, 'localhost', 3003
    end

    should "respond with osheet data" do
      assert_osheet_data 'rails three', RestClient.get("http://localhost:3003/things.xls")
    end

  end
end